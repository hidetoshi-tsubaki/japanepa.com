class Article < ApplicationRecord
  acts_as_taggable
  is_impressionable counter_cache: true
  has_many :bookmarks, dependent: :destroy
  has_many :users, through: :bookmarks
  has_many :like_articles, dependent: :destroy
  has_many :users, through: :like_articles
  has_one_attached :img
  validates :title, :contents, :lead, presence: true
  # 後でimageのバリでを復活

end
