module QuizzesHelper
  
  def getn5Quiz
     return {"Character(もじ)": %w(あ→A ア→A),
              "Word(ことば)": %w(Noun1 Noun2)}

      # 管理の方法考える、順番も容易に変更できるようにする
  end


# ここはチェックボックスとajaxで実装する
# def getQuizTitle(level)
#   case level
#   when "N5"
#     @n5QuizTitle
#   when "N4"
#     @n5QuizTitle
#   when "N3"
#     @n5QuizTitle
#   when "N2"
#     @n5QuizTitle
# end


end
