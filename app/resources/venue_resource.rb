class VenueResource < ApplicationResource
  attributes :extended_address, :notes
  has_one :location, always_include_linkage_data: true
  has_one :event, always_include_linkage_data: true
end
