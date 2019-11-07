class Article < ApplicationRecord
  acts_as_taggable
  is_impressionable counter_cache: true
  has_many :bookmarks, dependent: :destroy
  has_many :users, through: :bookmarks
  has_many :like_articles, dependent: :destroy
  has_many :users, through: :like_articles
  has_one_attached :img
  validate :img_presence
  validate :image_content_type
  validates :title, :contents, :lead, presence: true

  scope :bookmarks, -> (user) do
    includes(:bookmarks).where("bookmarks.user_id = user.id").order("bookmarks.created_at Desc")
  end
  scope :viewed_top_3, -> { with_attached_img.order(impressions_count: :desc).limit(3) }
  scope :bookmarked_top_3, -> { with_attached_img.order(bookmarks_count: :desc).limit(3) }
  scope :liked_top_3, -> { with_attached_img.order(likes_count: :desc).limit(3) }


end