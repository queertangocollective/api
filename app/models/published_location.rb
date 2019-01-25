class PublishedLocation < ApplicationRecord
  belongs_to :published_post
  belongs_to :location
end
