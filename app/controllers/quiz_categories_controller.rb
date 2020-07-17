class QuizCategoriesController < ApplicationController
  before_action :only_login_user!
  before_action :get_unchecked_announce_count, :get_not_done_reviews_count, :get_current_level

  def index
    @levels = QuizCategory.levels
    get_user_level
  end

  def show
    @level = QuizCategory.find(params[:id])
    @sections = @level.children.includes(:learning_levels, [categories: :quizzes])
  end
end
