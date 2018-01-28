class GroupResource < ApplicationResource
  attributes :name, :email, :hostname, :api_key, :timezone, :locale

  has_many :events
  has_many :transactions

  has_many :builds
  has_many :public_keys
  has_one :current_build, class_name: 'Build'

  filter :api_key

  def fetchable_fields
    if context[:current_user].try(:staff?)
      super
    else
      super - [:api_key]
    end
  end

  def self.records(options={})
    Group.where(id: options[:context][:group].id)
  end
end
