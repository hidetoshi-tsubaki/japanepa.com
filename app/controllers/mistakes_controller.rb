class MistakesController < ApplicationController
  before_action :authenticate_user!

  def show
    @category = QuizCategory.find(params[:id])
    set_valiables(params[:q],@category.id)
    @mistakes = @q.result(distinct: true).sorted
  end

  def destroy
    Mistake.find(params[:id]).destroy
  end

  def search
    @category = QuizCategory.find(params[:q][:title_id])
    if params[:q]['quiz_name_or_quiz_choice1_cont_any'] != nil
      
      set_valiables(params[:q],@category.id)
    else
      set_valiables(params[:q],@category.id)
      @mistakes = @q.result(distinct: true).sorted
    end
    render template: 'mistakes/show'
  end

  private

  def set_valiables(params,category)
    @q = current_user.mistakes.includes(:quiz)
        .where(title_id: category)
        .order(count: "DESC")
        .ransack(params)
  end

  def get_search_result(words)
      words = words.split(/[ ]/)
      @keywords = current_user.mistakes.includes(:quiz).ransack(params[:q])
      @mistakes = @keywords.result.sorted
  end
end
