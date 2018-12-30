class GroupResource < ApplicationResource
  attributes :name, :email, :hostname, :api_key, :timezone, :locale, :stripe_publishable_key, :stripe_secret_key, :apple_developer_merchantid_domain_association, :glitch_url

  has_many :events
  has_many :transactions
  has_many :channels

  has_many :builds
  has_many :public_keys
  has_one :current_build, class_name: 'Build'

  has_many :websites
  has_one :current_website, class_name: 'Website'

  def stripe_publishable_key
    if context[:api_key]
      @model.stripe_publishable_key
    end
  end

  def stripe_publishable_key=(publishable_key)
    key = ActiveSupport::KeyGenerator.new(ENV['STRIPE_SECRET']).generate_key(ENV['STRIPE_SALT'], 32)
    crypt = ActiveSupport::MessageEncryptor.new(key)
    @model.encrypted_stripe_publishable_key = crypt.encrypt_and_sign(publishable_key)
  end

  def stripe_secret_key
    if context[:api_key]
      @model.stripe_secret_key
    end
  end

  def stripe_secret_key=(secret_key)
    key = ActiveSupport::KeyGenerator.new(ENV['STRIPE_SECRET']).generate_key(ENV['STRIPE_SALT'], 32)
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
