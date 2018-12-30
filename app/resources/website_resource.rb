class WebsiteResource < ApplicationResource
  attributes :assets, :sha, :author

  before_create do
    @model.group = context[:group]
  end

  filters :pinned, :published, :slug

  def self.records(options={})
    if options[:context][:current_user].try(:staff?)
      context[:group].websites
    end
  end
end
