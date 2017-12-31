class Ticket < ApplicationRecord
  include PgSearch

  belongs_to :group
  has_many :ticketed_events
  has_many :events, through: :ticketed_events
  has_many :ticket_stubs

  validates_presence_of :description, :cost, :quantity

  pg_search_scope :search_for, against: %w(description), using: [:tsearch, :dmetaphone], ignoring: :accents
end
