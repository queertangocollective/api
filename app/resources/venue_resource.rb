class VenueResource < ApplicationResource
  attributes :extended_address, :notes
  belongs_to :location, always_include_linkage_data: true
  belongs_to :event, always_include_linkage_data: true
end
