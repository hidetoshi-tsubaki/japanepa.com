class Admin::QuizCategoriesController < ApplicationController
  before_action :authenticate_admin!

  def index
    @categories = QuizCategory.levels.page(params[:page])
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
    render :new_level
  end

  def new_category
    @parent = QuizCategory.find(params[:id])
    @category = @parent.is_section? ? TitleQuizExperienceForm.new : QuizCategory.new
    render :new_category
  end

  def new_quiz
    @category = QuizCategory.find(params[:id])
    @quiz = Quiz.new
  end

  def create
    @category = title_form?(params) ? TitleQuizExperienceForm.new(title_quiz_experience_params) : QuizCategory.new(category_params)
    if @category.save
      set_categories(@category)
      flash.now[:notice] = "新しいカテゴリーを作成しました！"
      render :create
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
    @parent = QuizCategory.find(params[:id])
    get_children_category(@parent)
    @parent.update(category_params)
    if @parent.save
      flash.now[:notice] = "カテゴリーを編集しました。"
      redirect_to edit_quiz_category_path(params[:id])
    else
      render 'edit'
    end
  end

  def destroy
    category = QuizCategory.find(params[:id])
    category.destroy
    flash.now[:notice] = '#{quiz_category.name}を削除しました。'
    if category.is_level?
      redirect_to admin_quiz_categories_path
    else
      redirect_to categories_admin_quiz_category_path(category.parent_id)
    end
  end

def search
    if params[:q]['name_or_introduction_or_users_name_cont_any'] != nil
      params[:q]['name_or_introduction_or_users_name_cont_any'] = params[:q]['name_or_introduction_or_users_name_cont_any'].split(/[ ]/)
      @keywords = Community.ransack(params[:q])
      @communities = @keywords.result.sorted.page(params[:page])
      @q = Community.ransack(params[:q])
    else
      @q = Community.ransack(params[:q])
      @communities = @q.result(distinct: true).sorted.page(params[:page])
    end
    render template: 'admin/communities/index'
  end

  def sort
    @category = QuizCategory.find(params[:id])
    child = @category.categories[params[:from].to_i]
    child.insert_at(params[:to].to_i + 1)
    head :ok
  end

  private

  def category_params
    params.require(:quiz_category).permit(:name, :parent_id)
  end

  def title_quiz_experience_params
    params.require(:title_quiz_experience_form).permit(:name, :parent_id, :experience)
  end

  def get_children_category(category)
    unless category.is_title?
      @categories = category.categories
    else
      @quizzes = category.quizzes
    end
  end

  def rendering(category)
    if category.parent_id
      @parent = QuizCategory.find(category.parent_id)
      render :new_category
    else
      render :new_level
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
    return params[:title_quiz_experience_form].present? ? true : false
  end

end
