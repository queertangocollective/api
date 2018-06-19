class Transaction < ActiveRecord::Base
  include PgSearch

  belongs_to :group
  belongs_to :receipt, optional: true, class_name: 'Photo', dependent: :destroy
  belongs_to :paid_by, optional: true, class_name: 'Person'
  has_many :ticket_stubs, foreign_key: :purchase_id
  has_many :tickets, through: :ticket_stubs

  validates_presence_of :description

  pg_search_scope :search_for, against: %w(description), associated_against: {
    paid_by: :name
  }, using: [:tsearch, :dmetaphone], ignoring: :accents
end
