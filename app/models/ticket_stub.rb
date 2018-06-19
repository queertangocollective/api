class TicketStub < ApplicationRecord
  include PgSearch

  belongs_to :group
  belongs_to :person
  belongs_to :event
  belongs_to :purchase, class_name: 'Transaction'
  belongs_to :ticket

  delegate :name, to: :person

  pg_search_scope :search_for, associated_against: { person: [:name, :email] },
                               using: [:tsearch, :dmetaphone], ignoring: :accents
end
