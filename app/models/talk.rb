class Talk < ApplicationRecord
  belongs_to :user
  belongs_to :community
  has_many :comments, dependent: :destroy
  has_many :like_talks, dependent: :destroy
  has_many :users, through: :like_talks
  mount_uploader :img, ImgUploader
  validates :content, uniqueness: { case_sensitive: false }
  validates :comunity_id, presence: true
end
