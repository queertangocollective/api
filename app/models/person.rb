class Person < ApplicationRecord
  include PgSearch
  pg_search_scope :search_for, against: %w(name email)

  belongs_to :group
  has_many :portraits
  has_many :photos, through: :portraits
  has_many :authorizations, dependent: :destroy
  has_many :authorization_sessions, through: :authorizations

  scope :public, -> { where(public: true) }

  def staff?
    role == 'staff'
  end
end
