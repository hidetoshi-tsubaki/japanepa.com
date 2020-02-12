class Event < ApplicationRecord
  is_impressionable counter_cache: true
  enum status: { draft: false, published: true }
  validates :name, :start_time, :detail, :status, presence: true
  validates :name, length: { in: 2..9 }
  validates :status, inclusion: { in: ["published", "draft"]}
end
