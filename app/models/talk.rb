class Talk < ApplicationRecord
  belongs_to :user
  belongs_to :community
  has_many :comments, dependent: :destroy
  mount_uploader :img, ImgUploader
end
