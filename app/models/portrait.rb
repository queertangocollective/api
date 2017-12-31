class Portrait < ApplicationRecord
  belongs_to :person
  belongs_to :photo
end

