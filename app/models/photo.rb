class Photo < ApplicationRecord
  belongs_to :group

  before_save :nullify_blank_values
  before_destroy :remove_remote_file

  def cloudfront_url
    "https://#{ENV['CLOUDFRONT_URL']}/#{s3_key}"
  end

  def cloudfront_url=(url)
    self.url = url
  end

  def s3_bucket
    ENV['S3_BUCKET_NAME']
  end

  def s3_key
    self.url.try(:gsub, "https://#{ENV['CLOUDFRONT_URL']}/", '')
            .try(:gsub, "https://#{s3_bucket}.s3.amazonaws.com/", '')
            .try(:gsub, '%2F', '/')
  end

  def remove_remote_file
    if s3_key
      s3 = AWS::S3.new
      photo = s3.buckets[s3_bucket].objects[s3_key].delete
    end
  end
end
