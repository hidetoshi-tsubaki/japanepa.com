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
    # quiz = Quiz.new(level:params[:level],section:params[:section],unit:params[:unit],
    # question:params[:question],choice1:params[choice1],choice2:params[choice2],
    # choice3:params[choice3],choice4:params[choice4])
    if @quiz.save
      # 成功時の処理
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
    @quizzes = Quiz.where(title: params[:title])
  end

  def edit
    @quiz = Quiz.find(params[:id])
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

  private

  def quiz_params
    params.require(:quiz).permit(:level, :section, :title, :question, :choice1, :choice2, :choice3, :choice4)
    # ここに書いてある値しか受け取らない 攻撃を受けないため
  end
end

