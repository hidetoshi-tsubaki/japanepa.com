class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  scope :sorted, -> { order(created_at: :desc) }
  scope :sort_and_paginate,-> (number) do
    order('created_at DESC').page(params[:page]).per(number)
  end

  def img_presence
    unless self.img.attached?
      errors.add(:img, 'must upload image')
    end
  end

  def image_content_type
    if self.img.attached?
      extension = ['image/png', 'image/jpg', 'image/jpeg']
      errors.add(:img, "you can upload only png, jpg and jpeg") unless img.content_type.in?(extension)
    end
  end

  def was_attached?
    self.img.attached?
  end
end
