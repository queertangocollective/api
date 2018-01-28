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

  def generate_api_key
    api_key = SecureRandom.hex
    self.api_key = Digest::SHA2.new(512).hexdigest(api_key)
    api_key
  end
end
