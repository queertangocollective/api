class PhotoResource < ApplicationResource
  attributes :width, :height, :filename, :filesize, :title, :caption, :tags
  attribute :url, delegate: :cloudfront_url
end
