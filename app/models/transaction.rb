class Transaction < ActiveRecord::Base
  include PgSearch

  belongs_to :group
  belongs_to :ticket, optional: true
  belongs_to :receipt, optional: true, class_name: 'Photo'
  belongs_to :paid_by, optional: true, class_name: 'Person'
  validates_presence_of :description

  pg_search_scope :search_for, against: %w(description), associated_against: {
    paid_by: :name
  }, using: [:tsearch, :dmetaphone], ignoring: :accents
end
