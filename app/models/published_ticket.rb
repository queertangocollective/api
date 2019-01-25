class PublishedTicket < ApplicationRecord
  belongs_to :published_post
  belongs_to :ticket
end
