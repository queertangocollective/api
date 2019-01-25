class PublishedChannel < ApplicationRecord
  belongs_to :published_post
  belongs_to :channel
end
