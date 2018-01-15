class S3DirectController < ApplicationController
  before_action :authorize

  def get
    if current_user
      render json: S3Direct.new(ENV['AWS_ACCESS_KEY_ID'], ENV['AWS_SECRET_ACCESS_KEY'], {
        bucket: ENV['S3_BUCKET_NAME'],
        acl: 'public-read',
        key: "uploads/#{current_user.group.id}/#{SecureRandom.uuid}-${filename}",
        expiration: Time.now + 10 * 60
      }).to_json
    else
      head :not_found
    end
  end
end
