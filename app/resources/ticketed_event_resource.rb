class TicketedEventResource < JSONAPI::Resource
  belongs_to :ticket, always_include_linkage_data: true
  belongs_to :event, always_include_linkage_data: true
end
