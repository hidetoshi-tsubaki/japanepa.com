class QuizzesController < ApplicationController
  before_action :authenticate_admin!, only: [:new, :create, :edit, :update, :delete, :edit_quiz_index]
  include QuizzesHelper
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
    @n5_quiz = get_n5_Quiz
  end

  def new
    @quiz = Quiz.new
  end

  def create
    @quiz = Quiz.new(quiz_params)
    if @quiz.save
      flash.now[:notice] = "registered successfully"
      redirect_to new_quiz_path
    else
      render "quizzes/new"
      flash.now[:notice] = "Failed to register.Try again"
    end
  end

  def quiz_title_index
    @n5_quiz = get_n5_Quiz
  end

  def edit_quiz_index
    @quizzes = Quiz.all
    @level_options = get_levels
    @level_options.unshift(["all level", 0, data: { quiz_select_list_path: all_quizzes_path }])
  end

  def edit
    @quiz = Quiz.find(params[:id])
    @level_options = get_levels
  end

  def update
    if Quiz.update(quiz_params)
      flash.now[:notice] = "updated successfully"
      redirect_to edit_quizzes_path
    else
      flash.now[:notice] = "Failed to update.Try again"
      render "quizzes/edit_quiz_index"
    end
  end

  def delete
    Quiz.find(params[:id]).destroy
    flash.now[:notice] = "edited quiz successfully!"
    redirect_to edit_quiz_index_path
  end

  def all_quizzes
    @quizzes = Quiz.all
  end

  def all_quizzes_in_level
    level = QuizCategory.find(params[:id])
    @quizzes = level.all_quizzes
  end

  def all_quizzes_in_section
    section = QuizCategory.find(params[:id])
    @quizzes = section.all_quizzes
  end

  def get_section_list
    @level = QuizCategory.find(params[:id])
    @section_list = get_sections(@level)
    path = "/all_quizzes_in_level/" + params[:id]
    add_options(params[:page], @section_list, path)
    render json: @section_list
  end

  def get_title_list
    @section = QuizCategory.find(params[:id])
    @title_list = get_titles(@section)
    path = "/all_quizzes_in_section/" + params[:id]
    add_options(params[:page], @title_list, path)
    render json: @title_list
  end

  def quizzes_in_title
    @quizzes = Quiz.get_quizzes_in(params[:id])
    render 'quiz_index'
  end

  private

  def quiz_params
    params.require(:quiz).permit(:level, :section, :title, :question, :choice1, :choice2, :choice3, :choice4)
  end

  def get_levels
    levels = (QuizCategory.where(depth: 0))
    levels.map do |level|
      [level.name, level.id, data: { quiz_select_path: quiz_section_list_path(level) }]
    end
  end

  def get_sections(level)
    QuizCategory.sections_in(level).map do |section|
    {name: section.name, value: section.id, path: quiz_title_list_path(section)}
    end
  end

  def get_titles(section)
    QuizCategory.titles_in(section).map do |title|
    {name: title.name, value: title.id, path: quizzes_in_title_path(title)}
    end
  end

  def add_options(page,valiable,path)
    p page
    if valiable.any?
      if page == "index_page"
        valiable.unshift({ name: "all",value: 0, path: path })
      end
      valiable.unshift({ name: "選択してください" })
    else
      valiable.unshift({ name: "なし" })
    end
  end

  # def
  # end
end

