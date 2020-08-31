class Admin::QuizCategoriesController < ApplicationController
  before_action :authenticate_admin!

  def index
    @categories = QuizCategory.levels
  end

  def categories
    @parent = QuizCategory.find(params[:id])
    @ancestors = @parent.get_ancestors
    get_children_category(@parent)
    if @parent.is_title?
      @quizzes = @parent.quizzes
    end
    render 'index'
  end

  def new_level
    @category = QuizCategory.new
    render "new_level"
  end

  def new_category
    @parent = QuizCategory.find(params[:id])
    @category = @parent.is_section? ? CategoryWithExperienceForm.new : QuizCategory.new
    render "new_category"
  end

  def new_quiz
    @category = QuizCategory.find(params[:id])
    @quiz = Quiz.new
  end

  def create
    @category = title_form?(params) ? CategoryWithExperienceForm.new(category_with_experience_params) : QuizCategory.new(category_params)
    if @category.save
      set_categories(@category)
      flash.now[:notice] = "新しいカテゴリーを作成しました！"
      render "create"
    else
      rendering(@category)
    end
  end

  def edit
    @category = QuizCategory.find(params[:id])
  end

  def edit_quiz
    @quiz = Quiz.find(params[:id])
  end

  def update
    @category = QuizCategory.find(params[:id])
    if @category.is_title?
      @category = CategoryWithExperienceForm.new(category_params)
      @category.update(category_params)
    else
      @category.update(category_params)
      if @category.save
        flash.now[:notice] = "カテゴリーを編集しました。"
      else
        render :edit
      end
    end
  end

  def destroy
    @category = QuizCategory.find(params[:id]).destroy
  end

  def sort
    if params[:id] == "undefined"
      category = QuizCategory.levels[params[:from].to_i]
      category.insert_at(params[:to].to_i + 1)
    else
      @category = QuizCategory.find(params[:id])
      child = @category.categories[params[:from].to_i]
      child.insert_at(params[:to].to_i + 1)
    end
  end

  private

  def category_params
    params.require(:quiz_category).permit(:name, :parent_id, :rate, :id)
  end

  def category_with_experience_params
    params.require(:category_with_experience_form).permit(:name, :parent_id, :rate)
  end

  def get_children_category(category)
    if category.is_title?
      @quizzes = category.quizzes
    else
      @categories = category.categories
    end
  end

  def rendering(category)
    if category.parent_id
      @parent = QuizCategory.find(category.parent_id)
      render "new_category"
    else
      render "new_level"
    end
  end

  def set_categories(category)
    if category.parent_id
      @parent = QuizCategory.find(category.parent_id)
      @categories = @parent.children
    else
      @categories = QuizCategory.where(depth: 0)
    end
  end

  def title_form?(params)
    params[:category_with_experience_form].present? ? true : false
  end

  def is_pagination?(params)
    if params[:q]['name_or_introduction_or_users_name_cont_any'].is_a?(Array)
      params[:q]['name_or_introduction_or_users_name_cont_any'] = params[:q]['name_or_introduction_or_users_name_cont_any'].join(" ")
    end
  end
end
