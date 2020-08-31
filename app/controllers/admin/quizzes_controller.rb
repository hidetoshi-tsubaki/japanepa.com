class Admin::QuizzesController < ApplicationController
  before_action :authenticate_admin!
  before_action :set_level_options, only: [:index, :search]

  def index
    @q = Quiz.includes(:category).ransack(params[:q])
    @quizzes = @q.result(distinct: true).paginate(params[:page], 15)
  end

  def new
    @quiz = Quiz.new
    @options = get_levels("new")
  end

  def create
    @quiz = Quiz.new(quiz_params)
    if from_category_page?(request)
      create_in_category_page(@quiz)
    else
      if @quiz.save
        flash.now[:notice] = "registered successfully"
        redirect_to admin_quizzes_path
      else
        @options = get_levels("index")
        @options.unshift({ name: "All", value: 0, path: all_admin_quizzes_path })
        render "admin/quizzes/new"
      end
    end
  end

  def edit
    @quiz = Quiz.find(params[:id])
  end

  def update
    @quiz = Quiz.find(params[:id])
    @quiz.update(quiz_params)
    if from_category_page?(request)
      create_in_category_page(@quiz)
    else
      if @quiz.save
        flash.now[:notice] = "updated successfully"
        redirect_to admin_quizzes_path
      else
        render 'edit'
      end
    end
  end

  def destroy
    Quiz.find(params[:id]).destroy
    if from_category_page?(request)
      flash.now[:notice] = "edited quiz successfully!"
      redirect_to admin_quiz_category_path(quiz.category_id)
    else
      flash.now[:notice] = "edited quiz successfully!"
      redirect_to admin_quizzes_path
    end
  end

  def search
    is_pagination?(params)
    if !params[:q]['question_or_choice1_cont_any'].nil?
      params[:q]['question_or_choice1_cont_any'] = params[:q]['question_or_choice1_cont_any'].split(/[ ]/)
      @keywords = Quiz.ransack(params[:q])
      @quizzes = @keywords.result.paginate(params[:page], 15)
      @q = Quiz.ransack(params[:q])
    else
      @q = Quiz.ransack(params[:q])
      @quizzes = @q.result(distinct: true).paginate(params[:page], 15)
    end
    render template: 'admin/quizzes/index'
  end

  def all_in_level
    level = QuizCategory.find(params[:id])
    all_title_in_level = level.leaves
    @q = Quiz.where(category_id: all_title_in_level).ransack(params[:q])
    @quizzes = @q.result(distinct: true).paginate(params[:page], 15)
    render 'narrow_down'
  end

  def all_in_section
    section = QuizCategory.find(params[:id])
    all_title_in_section = section.leaves
    @q = Quiz.where(category_id: all_title_in_section).ransack(params[:q])
    @quizzes = @q.result(distinct: true).paginate(params[:page], 15)
    render 'narrow_down'
  end

  def quizzes_in_title
    @q = Quiz.get_quizzes_in(params[:id].to_i).ransack(params[:q])
    @quizzes = @q.result(distinct: true)
    render 'narrow_down'
  end

  def get_section_list
    @level = QuizCategory.find(params[:id])
    current_page = params[:page]
    @options = get_sections(@level, current_page)
    # all_quizzes_in_level_path = "/all_quizzes_in_level/" + params[:id] + "/" + params[:page]
    add_options(current_page, @options, all_in_level_admin_quiz_path)
    render json: @options
  end

  def get_title_list
    @section = QuizCategory.find(params[:id])
    current_page = params[:page]
    @options = get_titles(@section, current_page)
    # get_all_quizzes_in_section_path = "/all_quizzes_in_section/" + params[:id] + "/" + current_page
    add_options(current_page, @options, all_in_section_admin_quiz_path)
    render json: @options
  end

  private

  def quiz_params
    question = ''
    extract_inner_text(params[:quiz][:question_html], question)
    params.require(:quiz).
      permit(:category_id, :question_html, :choice1, :choice2, :choice3, :choice4).
      merge(question: question)
  end

  def search_params
    params.require(:q).permit(:question_cont)
  end

  def extract_inner_text(html, question)
    q = html
    charset = nil
    doc = Nokogiri::HTML.parse(q, nil, charset)
    doc.css('p').each do |f|
      question << f.content
    end
  end

  def set_level_options
    @options = get_levels("index")
  end

  def get_levels(page)
    levels = QuizCategory.where(depth: 0)
    levels.map do |level|
      { name: level.name, value: level.id, path: admin_quiz_sections_path(id: level.id, page: page) }
    end
  end

  def get_sections(level, page)
    QuizCategory.sections_in(level).map do |section|
      { name: section.name, value: section.id, path: admin_quiz_titles_path(section, page) }
    end
  end

  def get_titles(section, page)
    QuizCategory.titles_in(section).map do |title|
      { name: title.name, value: title.id, path: quizzes_in_title_admin_quiz_path(title) }
    end
  end

  def add_options(page, valiable, path)
    if valiable.any?
      if page == "index"
        valiable.unshift({ name: "all", value: 0, path: path })
      end
      valiable.unshift({ name: "選択してください", value: '', path: '' })
    else
      valiable.unshift({ name: "なし", value: '', path: '' })
    end
  end

  def from_category_page?(request)
    request.referer&.include?("quiz_categories")
  end

  def create_in_category_page(quiz)
    if quiz.save!
      @quizzes = Quiz.where(category_id: quiz.category_id)
      flash.now[:notice] = "新しいクイズを作成しました！"
      render 'admin/quiz_categories/create_quiz'
    else
      @category = QuizCategory.find(quiz.category_id)
      render "admin/quiz_categories/new_quiz"
    end
  end

  def is_pagination?(params)
    if params[:q]['question_or_choice1_cont_any'].is_a?(Array)
      params[:q]['question_or_choice1_cont_any'] = params[:q]['question_or_choice1_cont_any'].join(" ")
    end
  end
end
