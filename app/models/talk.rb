class Talk < ApplicationRecord
  belongs_to :user
  mount_uploader :img, ImgUploader
end
