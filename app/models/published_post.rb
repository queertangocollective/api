class PublishedPost < ApplicationRecord
  belongs_to :group
  belongs_to :post
  belongs_to :channel, optional: true
  belongs_to :published_by, class_name: 'Person'

  has_many :published_channels, dependent: :destroy
  has_many :published_events, dependent: :destroy
  has_many :published_locations, dependent: :destroy
  has_many :published_people, dependent: :destroy
  has_many :published_photos, dependent: :destroy
  has_many :published_tickets, dependent: :destroy
end
