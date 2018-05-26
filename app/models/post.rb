class Post < ApplicationRecord
  include PgSearch

  validates_presence_of :title

  belongs_to :group
  has_many :authors

  pg_search_scope :search_for, against: %w(title)

  scope :pinned,    -> { where(pinned: true) }
  scope :published, -> { where(published: true) }
  scope :draft,     -> { where(published: false) }
end
