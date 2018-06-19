class Event < ApplicationRecord
  include PgSearch

  belongs_to :group
  belongs_to :venue, optional: true, dependent: :destroy
  has_many :ticket_stubs, dependent: :destroy
  has_many :ticketed_events, dependent: :destroy
  has_many :guests, dependent: :destroy

  validates_presence_of :title

  pg_search_scope :search_for, against: %w(title)
end
