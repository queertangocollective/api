class GuestResource < ApplicationResource
  attributes :role
  has_one :event, always_include_linkage_data: true
  has_one :person, always_include_linkage_data: true
end
