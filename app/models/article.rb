class Article < ApplicationRecord
  has_many :bookmarks, dependent: :destroy
  has_many :users, through: :bookmarks
  has_many :like_articles, dependent: :destroy
  has_many :users, through: :like_articles
  mount_uploader :img, ImgUploader
  is_impressionable
  validates :title, :contents, :img, :lead, presence: true
end
