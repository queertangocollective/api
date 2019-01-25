class Person < ApplicationRecord
  include PgSearch
  pg_search_scope :search_for, against: %w(name), using: [:tsearch, :dmetaphone], ignoring: :accents

  belongs_to :group
  has_many :portraits, dependent: :destroy
  has_many :photos, through: :portraits
  has_many :authorizations, dependent: :destroy
  has_many :authorization_sessions, through: :authorizations
  has_many :public_keys, dependent: :destroy
  has_many :published_people, dependent: :destroy

  scope :published, -> { where(published: true) }

  def staff?
    role == 'staff'
  end
end
