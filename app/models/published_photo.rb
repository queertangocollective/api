class PublishedPhoto < ApplicationRecord
  belongs_to :published_post
  belongs_to :photo
end
