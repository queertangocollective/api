class AuthorizationResource < ApplicationResource
  attributes :email, :avatar, :current_sign_in_at, :last_sign_in_at

  has_one :person
  has_one :group

  before_create do
    @model.group = context[:group]
  end

  def self.records(options={})
    if options[:context][:current_user].try(:staff?)
      options[:context][:group].authorizations
    end
  end
end
