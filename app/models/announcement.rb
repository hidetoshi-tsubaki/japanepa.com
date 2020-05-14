class Announcement < ApplicationRecord
  is_impressionable counter_cache: true
  enum status: { draft: false, published: true }
  validates :title, :contents, :status, presence: true
  validates :title, length: { in: 2..40 }
  validates :status, inclusion: { in: ["published", "draft"]}
end
