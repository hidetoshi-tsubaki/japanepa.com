class Announcement < ApplicationRecord
  is_impressionable counter_cache: true
  enum status: { draft: false, published: true }
  validates :title, :contents, :status, presence: true
  validates :title, length: { in: 2..40 }
  validates :contents, length: { in: 1..200000 }
  validates :status, inclusion: { in: ["published", "draft"] }

  has_many :announcement_checks, dependent: :destroy

  scope :published, -> { where(status: "published").order(id: "DESC") }
end
