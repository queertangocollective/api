class Build < ApplicationRecord
  belongs_to :group
  belongs_to :public_key

  validates :git_sha, presence: true
  validates :git_url, presence: true
  validates :signature, presence: true

  def verify
    matching_public_key.present?
  end

  def matching_public_key
    PublicKey.all
      .detect { |key| key.verify(self) }
      .tap { |key| self.public_key = key }
  end
end
