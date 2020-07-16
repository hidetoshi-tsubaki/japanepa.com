class ReviewsController < ApplicationController
  before_action :only_login_user!
  before_action :get_current_level, :get_unchecked_announce_count, :get_not_done_reviews_count

  def index
    reviews = current_user.reviews.includes(:quiz_category)
  end

  def destroy
    @review = Review.find(params[:id])
    @review.destroy
  end
end