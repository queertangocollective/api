class TicketStub < ApplicationRecord
  belongs_to :group
  belongs_to :person
  belongs_to :event
  belongs_to :purchase, class_name: 'Transaction'
  belongs_to :ticket
end
