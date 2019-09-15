class Admin::QuizCategoriesController < ApplicationController
  
  def levels
    @categories = QuizCategory.levels
    render 'show'
  end

  def show
    @parent = QuizCategory.find(params[:id])
    @ancestors = @parent.get_ancestors
    get_children_category(@parent)
    if @parent.is_title?
      @quizzes = @parent.quizzes
    end
  end

  def new_level
    @quiz_category = QuizCategory.new
  end

  def new_category
    @parent = QuizCategory.find(params[:id])
    @quiz_category = QuizCategory.new
  end

  def new_quiz
    @category = QuizCategory.find(params[:id])
    @quiz = Quiz.new
    render 'quizzes/form'
  end

  def create
    @quiz_category = QuizCategory.new(category_params)
    if @quiz_category.save
      flash.now[:notice] = "新しいカテゴリーを作成しました！"
      @categories = QuizCategory.levels
    else
      render "new"
      flash.now[:notice] = "カテゴリー作成に失敗しました..."
    end
  end

  def create_category
    if @parent = QuizCategory.find(params[:parent_id])
      @quiz_category = @parent.children.create(params[:name])
      if @quiz_category.valid?
        flash.now[:notice] = "新しいカテゴリーを作成しました！"
        redirect_to edit_quiz_category_path(@parent)
      else
        render "new_children"
        flash.now[:notice] = "カテゴリー作成に失敗しました..."
      end
    else
    end
  end

  def edit
    @quiz_category = QuizCategory.find(params[:id])
  end

  def edit_quiz
    @quiz = Quiz.find(params[:id])
    render 'quizzes/form'
  end

  def update
    @parent = QuizCategory.find(params[:id])
    get_children_category(@parent)
    @parent.update(category_params)
    if @parent.save
      flash.now[:notice] = "カテゴリーを編集しました。"
      redirect_to edit_quiz_category_path(params[:id])
    else
      flash.now[:alert] = "編集に失敗しました。"
      render 'edit'
    end
  end

  def delete
    category = QuizCategory.find(params[:id])
    category.destroy
    flash.now[:notice] = '#{quiz_category.name}を削除しました。'
    if category.level?
      redirect_to category_levels_path
    else
      redirect_to edit_quiz_category_path(category.parent.id)
    end
  end

  def sort
    @category = QuizCategory.find(params[:id])
    child = @category.categories[params[:from].to_i]
    child.insert_at(params[:to].to_i + 1)
    head :ok
  end

  private

  def category_params
    params.require(:quiz_category).permit(:name)
  end

  def get_children_category(category)
    unless category.is_title?
      @categories = category.categories
    else
      @quizzes = category.quizzes
    end
  end

end
