class Author < ApplicationRecord
  belongs_to :person
  belongs_to :post
end
