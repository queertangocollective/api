class TicketedEventResource < JSONAPI::Resource
  has_one :ticket, always_include_linkage_data: true
  has_one :event, always_include_linkage_data: true
end
