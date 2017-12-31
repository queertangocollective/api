class Event < ApplicationRecord
  include PgSearch

  belongs_to :group
  belongs_to :venue
  has_many :ticket_stubs

  validates_presence_of :title

  pg_search_scope :search_for, against: %w(title)
end
