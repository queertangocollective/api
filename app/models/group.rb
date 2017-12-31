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

  before_create :generate_api_key

  def generate_api_key
    begin
      self.api_key = SecureRandom.hex
    end while self.class.exists?(api_key: self.api_key)
  end
end
