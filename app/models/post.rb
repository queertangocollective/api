class Post < ApplicationRecord
  include PgSearch

  validates_presence_of :title

  belongs_to :group
  belongs_to :channel, optional: true
  has_many :authors, dependent: :destroy
  has_many :published_posts, dependent: :destroy

  pg_search_scope :search_for, against: %w(title)

  scope :pinned,    -> { where(pinned: true) }
  scope :published, -> { where(published: true) }
  scope :draft,     -> { where(published: false) }
end
