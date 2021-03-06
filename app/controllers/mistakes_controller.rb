class MistakesController < ApplicationController
  before_action :only_login_user!
  before_action :get_unchecked_announce_count, :get_not_done_reviews_count, except: :destroy

  def index
    @category = QuizCategory.find(params[:id])
    set_valiables(params[:q], @category.id)
    @mistakes = @q.result(distinct: true).sorted
  end

  def destroy
    @mistake = Mistake.find(params[:id]).destroy
  end

  def search
    @category = QuizCategory.find(params[:q][:title_id])
    if !params[:q]['quiz_name_or_quiz_choice1_or_quiz_choice2_or_quiz_choice3_or_quiz_choice4_cont_any'].nil?
      params[:q]['
        quiz_name_or_quiz_choice1_or_quiz_choice2_or_quiz_choice3_or_quiz_choice4_cont_any'
      ] = params[:q][
        'quiz_name_or_quiz_choice1_or_quiz_choice2_or_quiz_choice3_or_quiz_choice4_cont_any'
      ].split(/[ ]/)
      set_valiables(params[:q], @category.id)
    else
      set_valiables(params[:q], @category.id)
      @mistakes = @q.result(distinct: true).sorted
    end
    render template: 'mistakes/index'
  end

  private

  def set_valiables(params, category)
    @q = current_user.mistakes.includes(:quiz).
      where(title_id: category).
      order(count: "DESC").
      ransack(params)
  end
end
