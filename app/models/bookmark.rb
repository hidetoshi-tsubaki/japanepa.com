class Bookmark < ApplicationRecord
  belongs_to :user
  belongs_to :article
  validate :user_id, :article_id, presence: true
  validates :user_id, :uniqueness => { :scope => :article_id }
end