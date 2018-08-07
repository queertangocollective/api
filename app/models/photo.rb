class Photo < ApplicationRecord
  include PgSearch

  belongs_to :group

  before_destroy :remove_remote_file

  pg_search_scope :search_for, against: %w(filename title), using: [:tsearch, :dmetaphone], ignoring: :accents

  def cloudfront_url
    "https://#{ENV['CLOUDFRONT_URL']}/#{s3_key}"
  end

  def cloudfront_url=(url)
    self.url = url
  end

  def s3_bucket
    ENV['AWS_BUCKET_NAME']
  end

  def s3_key
    self.url.try(:gsub, "https://#{ENV['CLOUDFRONT_URL']}/", '')
            .try(:gsub, "https://#{s3_bucket}.s3.amazonaws.com/", '')
            .try(:gsub, '%2F', '/')
            .try(:gsub, '+', ' ')
  end

  def remove_remote_file
    if s3_key
      s3 = Aws::S3::Resource.new
      bucket = s3.bucket(s3_bucket)
      object = bucket.object(s3_key)
      if object.exists?
        object.delete
      end
    end
  end
end
