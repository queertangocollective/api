class ChannelResource < ApplicationResource
  attributes :locale, :name, :slug, :published

  before_create do
    @model.group = context[:group]
  end

  def self.records(options={})
    options[:context][:group].channels
  end
end
