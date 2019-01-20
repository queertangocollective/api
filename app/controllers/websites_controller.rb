require 'open-uri'

class WebsitesController < ApplicationController
  before_action :authorize

  def create
    FileUtils.rm_rf("/tmp/glitch-sync/#{group.name.parameterize}")
    repository = Git.clone(group.glitch_url, group.name.parameterize, path: "/tmp/glitch-sync")
    commit = repository.gcommit('HEAD')

    return if Website.find_by(sha: commit.sha)

    repository.chdir do
      templates = Dir.glob("views/*.hbs").map do |path|
        {
          path: path,
          file: File.read("#{Dir.pwd}/#{path}")
        }
      end

      image_urls = []
      css_entry_points = []
      script_entry_points = []

      # Collect all images embedded into HTML
      templates.each do |template|
        doc = Nokogiri::HTML(template[:file])
        image_urls << doc.search('img').map { |image| image["src"] }
        image_urls << doc.search('link[rel="apple-touch-icon"], link[rel="shortcut"]').map { |image| image["href"] }

        css_entry_points << doc.search('link[rel="stylesheet"]').map { |stylesheet| stylesheet["href"] }
        script_entry_points << doc.search('script[src]').map { |script| script["src"] }
      end

      css_entry_points.flatten!.uniq!
      script_entry_points.flatten!.uniq!
      image_urls = image_urls.flatten.uniq.select do |url|
        url.present? && url.match('{{').nil? && url.match('}}').nil?
      end

      sass_files = []
      css_entry_points.each do |filename|
        filename.gsub!(".css", "")
        if File.exist?("#{Dir.pwd}/public#{filename}.sass")
          sass_files << "public#{filename}.sass"
        elsif File.exist?("#{Dir.pwd}/public#{filename}.scss")
          sass_files << "public#{filename}.scss"
        elsif File.exist?("#{Dir.pwd}/public#{filename}.css")
          sass_files << "public#{filename}.css"
        end
      end

      styles = sass_files.map do |path|
        css = SassC::Engine.new(File.read("#{Dir.pwd}/#{path}"), style: :nested, load_paths: ["#{Dir.pwd}/public"]).render
        path = path.gsub(/.s[ac]ss$/, ".css")
        prefixed_css = AutoprefixerRails.process(css, from: path, browsers: ['last 2 versions']).css
        {
          path: path,
          file: prefixed_css
        }
      end

      scripts = script_entry_points.map do |path|
        js = File.read("#{Dir.pwd}/public#{path}")
        filename = path.split('/').last
        relative_path = "#{Dir.pwd}/#{path.split('/')[0..-1].join('/')}"
        compiled_js = Babel::Transpiler.transform(js, {
          'sourceRoot' => "#{Dir.pwd}/public#{path}",
          'moduleRoot' => nil,
          'filename' => filename,
          'filenameRelative' => relative_path
        })

        {
          path: "public#{path}",
          file: compiled_js['code']
        }
      end

      uploaded_urls = []

      image_urls.each do |image_url|
        image = open(image_url)
        extension = File.extname(image_url.gsub(/\?\d+/, ''))
        basename = File.basename(image_url.gsub('%2F', '/').gsub('+', ' ').gsub(/\?\d+/, ''), extension)
        filename = "#{basename}-#{Digest::SHA256.file(image.path).hexdigest[0..12]}#{extension}"

        s3 = Aws::S3::Resource.new
        bucket_name = ENV['AWS_BUCKET_NAME']
        bucket = s3.bucket(bucket_name)
        bucket.object("assets/#{filename}").upload_file(image.path, acl: 'public-read')

        uploaded_urls << "https://#{ENV['CLOUDFRONT_URL']}/assets/#{filename}"
      end

      templates.each do |template|
        image_urls.each_with_index do |glitch_url, index|
          resolved_url = uploaded_urls[index]
          template[:file] = template[:file].gsub(glitch_url, resolved_url)
        end
      end

      assets = {}
      templates.each do |template|
        assets[template[:path]] = template[:file]
      end
      styles.each do |styles|
        assets[styles[:path]] = styles[:file]
      end
      scripts.each do |script|
        assets[script[:path]] = script[:file]
      end

      website = Website.create({
        group: group,
        sha: commit.sha,
        assets: assets
      })
      group.current_website = website
      group.save
    end
  end
end
