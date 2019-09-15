class Admin::QuizzesController < ApplicationController
  # before_action :authenticate_admin!, only: [:new, :create, :edit, :update, :delete, :edit_quiz_index]

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
    if params[:q] != nil
      params[:q][:question_or_choice1_cont_any] = params[:q][:question_or_choice1_cont_any]
                                                  .split(/p[{blank}\s]+/)
      keyword = Quiz.rancsack(params[:q])
      @quizzes = keyword.result
    else
      keyword = Quiz.ransack(params[:q])
      @quizzes = keyword.result
    end
    @options = get_levels("index")
    @options.unshift({name: "All", value: 0, path: all_admin_quizzes_path })
  end

  def new
    @quiz = Quiz.new
    @options = get_levels("new")
    @options.unshift({name: "All", value: 0, path: all_admin_quizzes_path })
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
        flash.now[:notice] = "Failed to register.Try again"
          @options = get_levels("index")
          @options.unshift({name: "All", value: 0, path: all_admin_quizzes_path })
        render "admin/quizzes/new"
      end
    end
  end

  def edit
    @quiz = Quiz.find(params[:id])
    render 'edit_form'
  end

  def update
    @quiz = Quiz.find(params[:id])
    @quiz.update(quiz_params)
    if from_category_page?(request)
      create_in_category_page(@quiz)
    else
      if @quiz.save
        flash.now[:notice] = "updated successfully"
      else
        render "quizzes/form"
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
    redirect_to admin_quizzes_path
    end
  end

  def search
    @q = Quiz.search(search_params)
    @quizzes = @q.result(distinct: true)
  end

  def all
    @quizzes = Quiz.all
    render 'narrow_down'
  end

  def all_in_level
    level = QuizCategory.find(params[:id])
    @quizzes = level.quizzes
    render 'narrow_down'
  end

  def all_in_section
    section = QuizCategory.find(params[:id])
    @quizzes = section.quizzes
    render 'narrow_down'
  end

  def quizzes_in_title
    @quizzes = Quiz.get_quizzes_in(params[:id].to_i)
    render 'admin/quizzes/narrow_down'
  end

  def get_section_list
    @level = QuizCategory.find(params[:id])
    current_page = params[:page]
    @options = get_sections(@level,current_page)
    all_quizzes_in_level_path = "/all_quizzes_in_level/" + params[:id] + "/" + params[:page]
    add_options(current_page, @options, all_in_level_admin_quiz_path)
    render json: @options
  end

  def get_title_list
    @section = QuizCategory.find(params[:id])
    current_page = params[:page]
    @options = get_titles(@section,current_page)
    get_all_quizzes_in_section_path = "/all_quizzes_in_section/" + params[:id] + "/" + current_page
    add_options(current_page, @options, all_in_section_admin_quiz_path)
    render json: @options
  end

  private

  def quiz_params
    params.require(:quiz).permit(:category_id, :question, :choice1, :choice2, :choice3, :choice4)
  end

  def searck_params
    params.require(:q).permit(:question_cont)
  end

  def get_levels(page)
    levels = (QuizCategory.where(depth: 0))
    options = levels.map do |level|
      { name: level.name, value: level.id, path: admin_quiz_sections_path(id: level.id, page: page) }
    end
  end

  def get_sections(level,page)
    QuizCategory.sections_in(level).map do |section|
      { name: section.name, value: section.id, path: admin_quiz_titles_path(section,page) }
    end
  end

  def get_titles(section,page)
    QuizCategory.titles_in(section).map do |title|
      { name: title.name, value: title.id, path: quizzes_in_title_admin_quiz_path(title) }
    end
  end

  def add_options(page,valiable,path)
    if valiable.any?
      if page == "index"
        valiable.unshift({ name: "all",value: 0, path: path })
      end
      valiable.unshift({ name: "選択してください", value: '', path: ''})
    else
      valiable.unshift({ name: "なし", value: '', path: ''})
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
      render "admin/quizzes/form"
    end
  end

end

