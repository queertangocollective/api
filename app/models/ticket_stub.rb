class TicketStub < ApplicationRecord
  belongs_to :group
  belongs_to :person
  belongs_to :event
  belongs_to :transaction
  belongs_to :ticket
end
