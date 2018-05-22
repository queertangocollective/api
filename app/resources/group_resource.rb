class GroupResource < ApplicationResource
  attributes :name, :email, :hostname, :api_key, :timezone, :locale, :stripe_publishable_key, :stripe_secret_key

  has_many :events
  has_many :transactions

  has_many :builds
  has_many :public_keys
  has_one :current_build, class_name: 'Build'

  def stripe_publishable_key
    if context[:api_key] && @model.encrypted_stripe_publishable_key
      key = ActiveSupport::KeyGenerator.new(context[:api_key]).generate_key(Rails.application.secret_key_base)
      crypt = ActiveSupport::MessageEncryptor.new(key)
      crypt.decrypt_and_verify(@model.encrypted_stripe_publishable_key)
    end
  end

  def stripe_publishable_key=(publishable_key)
    key = ActiveSupport::KeyGenerator.new(context[:api_key]).generate_key(Rails.application.secret_key_base)
    crypt = ActiveSupport::MessageEncryptor.new(key)
    @model.encrypted_stripe_publishable_key = crypt.encrypt_and_sign(publishable_key)
  end

  def stripe_secret_key
    if context[:api_key] && @model.encrypted_stripe_secret_key
      key = ActiveSupport::KeyGenerator.new(context[:api_key]).generate_key(Rails.application.secret_key_base)
      crypt = ActiveSupport::MessageEncryptor.new(key)
      crypt.decrypt_and_verify(@model.encrypted_stripe_secret_key)
    end
  end

  def stripe_secret_key=(secret_key)
    key = ActiveSupport::KeyGenerator.new(context[:api_key]).generate_key(Rails.application.secret_key_base)
    crypt = ActiveSupport::MessageEncryptor.new(key)
    @model.encrypted_stripe_secret_key = crypt.encrypt_and_sign(secret_key)
  end

  def fetchable_fields
    if context[:current_user].try(:staff?)
      super
    else
      super - [:api_key, :stripe_secret_key]
    end
  end

  def self.records(options={})
    Group.where(id: options[:context][:group].id)
  end
end
