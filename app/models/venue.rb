class Venue < ApplicationRecord
  belongs_to :location
  belongs_to :event
end
