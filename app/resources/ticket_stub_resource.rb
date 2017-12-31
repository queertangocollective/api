class TicketStubResource < ApplicationResource
  attributes :attended, :role, :level, :notes

  has_one :person
  has_one :event
  has_one :transaction
  has_one :ticket

  before_create do
    @model.group = context[:group]
  end

  def self.records(options={})
    if options[:context][:current_user].try(:staff?)
      options[:context][:group].ticket_stubs
    end
  end
end
