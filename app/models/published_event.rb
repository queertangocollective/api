class PublishedEvent < ApplicationRecord
  belongs_to :published_post
  belongs_to :event
end
