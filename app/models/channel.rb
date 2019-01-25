class Channel < ApplicationRecord
  include PgSearch

  belongs_to :group
  has_many :posts
  has_many :published_channels, dependent: :destroy

  validates_presence_of :name, :slug

  pg_search_scope :search_for, against: %w(name slug)
end
