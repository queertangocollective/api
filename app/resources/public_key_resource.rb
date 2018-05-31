class PublicKeyResource < ApplicationResource
  attributes :name, :fingerprint, :key, :last_used_at

  has_one :group
  has_one :person

  before_create do
    @model.group = context[:group]
    @model.person = context[:current_user]
  end

  def fingerprint
    @model.fingerprint
  end

  def last_used_at
    @model.builds.order('created_at desc').limit(1).first.try(:created_at)
  end

  def updateable_fields
    super - [:name, :fingerprint, :key, :last_used_at, :person, :group]
  end

  def creatable_fields
    super - [:fingerprint, :last_used_at, :person, :group]
  end

  def fetchable_fields
    super - [:key]
  end

  def self.records(options={})
    if options[:context][:current_user].try(:staff?)
      options[:context][:current_user].public_keys
    end
  end
end
