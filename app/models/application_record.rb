class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
  scope :sort_and_paginate,-> (number) do
    order('created_at DESC').page(params[:page]).per(number)
  end
end
