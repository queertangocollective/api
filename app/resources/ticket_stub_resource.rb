class TicketStubResource < ApplicationResource
  attributes :attended, :role, :level, :notes

  has_one :person, always_include_linkage_data: true
  has_one :event, always_include_linkage_data: true
  has_one :purchase, class_name: 'Transaction', always_include_linkage_data: true
  has_one :ticket, always_include_linkage_data: true

  filter :event_id
  filter :ticket_id

  before_create do
    @model.group = context[:group]
  end

  def self.records(options={})
    if options[:context][:current_user].try(:staff?)
      options[:context][:group].ticket_stubs
    end
  end

  def self.sortable_fields(context)
    super(context) + [:"purchase.paid_at", :"person.name", :"person.email", :"purchase.amount_paid"]
  end
end
