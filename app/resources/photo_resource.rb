class PhotoResource < ApplicationResource
  attributes :width, :height, :filename, :filesize, :title, :caption, :tags
  attribute :url, delegate: :cloudfront_url

  before_create do
    @model.group = context[:group]
  end

  def self.records(options={})
    options[:context][:group].photos
  end
end
