class QuizzesController < ApplicationController
  include QuizzesHelper
  before_action :only_login_user!
  before_action :get_unchecked_announce_count, :get_current_level

  def play
    @category = QuizCategory.find(params[:id])
    # title表示のため
    @quizzes = Quiz.where(category_id: params[:id])
    set_quizzes(@categroy)
  end

  def play_mistakes
    @category = QuizCategory.find(params[:id])
    if mistake_ids = current_user.mistakes.where(title_id: @category.id).pluck(:quiz_id)
      @quizzes = Quiz.where(id: mistake_ids)
      set_quizzes(@categroy)
      render :play
    else
      @levels = QuizCategory.includes(categories: :quizzes).levels
      render :index 
      flash[:alert] = "there is no mistake record"
    end
  end

  def index
    @levels = QuizCategory.includes(categories: :quizzes).levels
    get_user_level
  end

  def sections
    @level = QuizCategory.find(params[:id])
    @sections = sections_in(@level)
  end

  def titles
    @sections = QuizCategroy.find(params[:id])
    @titles = titles_in(@section)
  end

  private

  def set_quizzes(category)
    gon.quizTitle = @category.name
    gon.title_id = @category.id
    gon.quizSet = []
    @quizzes.each do |quiz|
      gon.quizSet.push(id: "#{quiz.id}", question: "#{quiz.question}", choices: ["#{quiz.choice1}", "#{quiz.choice2}", "#{quiz.choice3}", "#{quiz.choice4}"])
    end
  end
end