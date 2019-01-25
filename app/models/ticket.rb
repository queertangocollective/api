class Ticket < ApplicationRecord
  include PgSearch

  belongs_to :group
  has_many :ticketed_events, dependent: :destroy
  has_many :ticket_stubs, dependent: :destroy
  has_many :purchases, through: :ticket_stubs
  has_many :events, through: :ticketed_events
  has_many :published_tickets, dependent: :destroy

  validates_presence_of :description, :cost, :quantity

  pg_search_scope :search_for, against: %w(description), using: [:tsearch, :dmetaphone], ignoring: :accents
end
