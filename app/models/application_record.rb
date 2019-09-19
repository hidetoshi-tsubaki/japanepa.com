class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  scope :sorted, -> { order(created_at: :desc) }
  scope :sort_and_paginate,-> (number) do
    order('created_at DESC').page(params[:page]).per(number)
  end
end
