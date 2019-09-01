class QuizCategoriesController < ApplicationController
  
  def levels
    @categories = QuizCategory.levels
    render 'edit'
  end

  def new
    @quiz_category = QuizCategory.new
  end

  def new_children
    @parent = QuizCategory.find(params[:id])
    @quiz_category = QuizCategory.new
  end

  def create
    @quiz_category = QuizCategory.new(category_params)
    if @quiz_category.save
      flash.now[:notice] = "新しいカテゴリーを作成しました！"
      redirect_to category_levels_path
    else
      render "new"
      flash.now[:notice] = "カテゴリー作成に失敗しました..."
    end
  end

  def create_children
    @parent = QuizCategory.find(params[:parent_id])
    @quiz_category = @parent.children.create(params[:name])
    if @quiz_category.valid?
      flash.now[:notice] = "新しいカテゴリーを作成しました！"
      redirect_to edit_quiz_category_path(@parent)
    else
      render "new_children"
      flash.now[:notice] = "カテゴリー作成に失敗しました..."
    end
  end

  def edit
    @parent = QuizCategory.find(params[:id])
    @ancestors = @parent.ancestors
    get_children_category(@parent)
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
    quiz_category = QuizCategory.find(params[:id])
    quiz_category.destroy
    flash.now[:notice] = '#{quiz_category.name}を削除しました。'
    if @parent.parent_id.nil?
      redirect_to category_levels
    else
      redirect_to edit_quiz_category_path(@parent.id)
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

  def get_children_category(parent)
    unless parent.depth == 3
      @categories = parent.categories
    else
      @quizzes = parent.quizzes
    end
  end

end
