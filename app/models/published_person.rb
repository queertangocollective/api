class PublishedPerson < ApplicationRecord
  belongs_to :published_post
  belongs_to :person
end
