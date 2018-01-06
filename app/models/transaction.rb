class Transaction < ActiveRecord::Base
  include PgSearch

  belongs_to :group
  belongs_to :ticket, optional: true
  belongs_to :receipt, optional: true, class_name: 'Photo'
  validates_presence_of :description, :amount_paid, :currency, :paid_by

  pg_search_scope :search_for, against: %w(description paid_by), using: [:tsearch, :dmetaphone], ignoring: :accents
end
