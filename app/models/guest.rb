class Guest < ApplicationRecord
  include PgSearch

  belongs_to :person
  belongs_to :event
end
