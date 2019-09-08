class Admin::QuizzesController < ApplicationController
  before_action :authenticate_admin!, only: [:new, :create, :edit, :update, :delete, :edit_quiz_index]

  def show
    @quizzes = Quiz.where(title: params[:title])
    # あとでsanitizeする
    # ページのタイトルを呼び出せるし、ページでscoreのpramsを送るときに
    # title: quizzes.unitTitleでいけるbjt@94563
    gon.title = params[:title]
    gon.user_id = current_user.id
    gon.quizSet = []
    @quizzes.each do |quiz|
      gon.quizSet.push(q: "#{quiz.question}", c: ["#{quiz.choice1}", "#{quiz.choice2}", "#{quiz.choice3}", "#{quiz.choice4}"])
    end
    gon.quizSet.shuffle!
  end

  def index
    @categories = QuizCategory.levels
  end

  def new
    @quiz = Quiz.new
  end

  def create
    @quiz = Quiz.new(quiz_params)
    if from_category_page?(request)
      create_in_category_page(@quiz)
    else
      if @quiz.save
        flash.now[:notice] = "registered successfully"
        redirect_to new_quiz_path
      else
        flash.now[:notice] = "Failed to register.Try again"
        render "quizzes/new"
        #あとでflashを対応させる
      end
    end
  end

  def quiz_title_index
    # @n5_quiz = get_n5_Quiz
  end

  def edit_quiz_index
    @quizzes = Quiz.all
    @level_options = get_levels("index_page")
    @level_options.unshift(["all level", 0, data: { quiz_select_path: all_quizzes_path }])
  end

  def edit
    @quiz = Quiz.find(params[:id])
    @level_options = get_levels("edit_page")
  end

  def update
    @quiz = Quiz.find(params[:id])
    @quiz.update(quiz_params)
    if from_category_page?(request)
      create_in_category_page(@quiz)
    else
      if @quiz.save
        flash.now[:notice] = "updated successfully"
        redirect_to edit_quizzes_path
      else
        flash.now[:notice] = "Failed to update.Try again"
        render "quizzes/edit_quiz_index"
      end
    end
  end

  def destroy
    quiz = Quiz.find(params[:id])
    quiz.destroy
    if from_category_page?(request)
      flash.now[:notice] = "edited quiz successfully!"
      redirect_to admin_quiz_category_path(quiz.category_id)
    else
    flash.now[:notice] = "edited quiz successfully!"
    end
  end

  def all_quizzes
    @quizzes = Quiz.all
    render 'quiz_index'
  end

  def all_quizzes_in_level
    level = QuizCategory.find(params[:id])
    @quizzes = level.all_quizzes
    render 'quiz_index'
  end

  def all_quizzes_in_section
    section = QuizCategory.find(params[:id])
    @quizzes = section.all_quizzes
    render 'quiz_index'
  end

  def get_section_list
    @level = QuizCategory.find(params[:id])
    current_page = params[:page]
    @section_list = get_sections(@level,current_page)
    all_quizzes_in_level_path = "/all_quizzes_in_level/" + params[:id] + "/" + params[:page]
    add_options(current_page, @section_list, all_quizzes_in_level_path)
    render json: @section_list
  end

  def get_title_list
    @section = QuizCategory.find(params[:id])
    current_page = params[:page]
    @title_list = get_titles(@section,current_page)
    get_all_quizzes_in_section_path = "/all_quizzes_in_section/" + params[:id] + "/" + current_page
    add_options(current_page, @title_list, get_all_quizzes_in_section_path)
    render json: @title_list
  end

  def quizzes_in_title
    @quizzes = Quiz.get_quizzes_in(params[:id].to_i)
    render 'quiz_index'
  end

  private

  def quiz_params
    params.require(:quiz).permit(:category_id, :question, :choice1, :choice2, :choice3, :choice4)
  end

  def get_levels(page)
    levels = (QuizCategory.where(depth: 0))
    levels.map do |level|
      [level.name, level.id, data: { quiz_select_path: quiz_section_list_path(level,page) }]
    end
  end

  def get_sections(level,page)
    QuizCategory.sections_in(level).map do |section|
    {name: section.name, value: section.id, path: quiz_title_list_path(section,page)}
    end
  end

  def get_titles(section,page)
    QuizCategory.titles_in(section).map do |title|
    {name: title.name, value: title.id, path: quizzes_in_title_path(title,page)}
    end
  end

  def add_options(page,valiable,path)
    if valiable.any?
      if page == "index_page"
        valiable.unshift({ name: "all",value: 0, path: path })
      end
      valiable.unshift({ name: "選択してください" })
    else
      valiable.unshift({ name: "なし" })
    end
  end

  def from_category_page?(request)
    request.referer&.include?("quiz_categories")
  end

  def create_in_category_page(quiz)
    if quiz.save
      @quizzes = Quiz.where(category_id: quiz.category_id)
      respond_to do |format|
        format.js { flash[:notice] = 'quiz was registered successfully' }
      end
      render "admin/quiz_categories/show"
    else
      render "admin/quiz_categories/quiz_form"
    end
  end

end

