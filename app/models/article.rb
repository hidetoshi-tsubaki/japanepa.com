class Article < ApplicationRecord
  mount_uploader :image, ImgUploader
end
