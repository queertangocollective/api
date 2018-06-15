class Event < ApplicationRecord
  include PgSearch

  belongs_to :group
  belongs_to :venue, optional: true
  has_many :ticket_stubs
  has_many :ticketed_events
  has_many :guests

  validates_presence_of :title

  pg_search_scope :search_for, against: %w(title)
end
