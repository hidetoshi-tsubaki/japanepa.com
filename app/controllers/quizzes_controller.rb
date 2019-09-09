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
    @n5_quiz = QuizCategory.levels
  end

end