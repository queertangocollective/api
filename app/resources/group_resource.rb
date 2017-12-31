class GroupResource < ApplicationResource
  attributes :name, :email, :hostname, :api_key

  has_many :events
  has_many :transactions

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
