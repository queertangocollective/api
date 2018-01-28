class PublicKeyResource < ApplicationResource
  attributes :name, :fingerprint, :last_used_at

  has_one :group

  before_create do
    @model.group = context[:group]
  end

  def fingerprint
    @model.fingerprint
  end

  def last_used_at
    @model.builds.order('created_at desc').limit(1).first.try(:created_at)
  end

  def self.records(options={})
    if options[:context][:current_user].try(:staff?)
      options[:context][:group].public_keys
    end
  end
end
