class Group < ApplicationRecord
  has_many :authorizations
  has_many :people
  has_many :photos
  has_many :posts
  has_many :events
  has_many :locations
  has_many :transactions
  has_many :tickets
  has_many :ticket_stubs
  has_many :public_keys
  has_many :builds

  belongs_to :current_build, optional: true, class_name: 'Build'

  def stripe_publishable_key
    if encrypted_stripe_publishable_key
      key = ActiveSupport::KeyGenerator.new(ENV['STRIPE_SECRET']).generate_key(ENV['STRIPE_SALT'], 32)
      crypt = ActiveSupport::MessageEncryptor.new(key)
      crypt.decrypt_and_verify(encrypted_stripe_publishable_key)
    else
      nil
    end
  end

  def stripe_secret_key
    if encrypted_stripe_secret_key
      key = ActiveSupport::KeyGenerator.new(ENV['STRIPE_SECRET']).generate_key(ENV['STRIPE_SALT'], 32)
      crypt = ActiveSupport::MessageEncryptor.new(key)
      crypt.decrypt_and_verify(encrypted_stripe_secret_key)
    else
      nil
    end
  end

  def generate_api_key
    api_key = SecureRandom.hex
    self.api_key = Digest::SHA2.new(512).hexdigest(api_key)
    api_key
  end
end
