class QuizzesController < ApplicationController
  include  QuizzesHelper
  def show
    @quizzes = Quiz.where(title: params[:title])
    #あとでsanitizeする 


    # ページのタイトルを呼び出せるし、ページでscoreのpramsを送るときに
    # title: quizzes.unitTitleでいけるbjt@94563
    gon.title = params[:title]
    gon.user_id = current_user.id
    gon.quizSet=[]
      @quizzes.each do |quiz| 
      gon.quizSet.push(q:"#{quiz.question}",c:["#{quiz.choice1}","#{quiz.choice2}","#{quiz.choice3}","#{quiz.choice4}"])
    end
  
    gon.quizSet.shuffle!
  end

  def index
    @n5Quiz = getn5Quiz()
  end

  def new
    @quiz =Quiz.new
  end

  def create
    @quiz = Quiz.new(quiz_params)
    # quiz = Quiz.new(level:params[:level],section:params[:section],unit:params[:unit],
    #                   question:params[:question],choice1:params[choice1],choice2:params[choice2],
    #                   choice3:params[choice3],choice4:params[choice4])
    if @quiz.save
      # 成功時の処理
      redirect_to  quizzes_new_path
      flash.now[:notice] = "registered successfully"
    else
      render "quizzes/new"
      flash.now[:notice] = "Failed to register.Try again"
    end
  end

  def edit
    @quiz = Quiz.find(params[:id])
  end

private
  # 直接呼び出せないメソッドの中からしか呼び出せない
  def quiz_params
  params.require(:quiz).permit(:level,:section,:title,:question,:choice1,:choice2,:choice3,:choice4)
  # ここに書いてある値しか受け取らない 攻撃を受けないため
  end

  def quiz_title_params
    params.require(:quiz).permit(:title)
  end

end
