module QuizzesHelper
     # @n5Quiz= ["Character(もじ)": %w(あ→A ア→A あ→ア ア→あ A→あ A→ア),
    #           "Word(ことば)": %w(Noun1 Noun2 Noun3 Noun4 Noun5 Time1 Time2 Verb1 Verb2 Adjective1 Adjective2 Interrogative),
    #           "Kanji(かんじ)": %w(part1 part2 part3 part4 part5)]
  def getn5Quiz
     return {"Character(もじ)": %w(あ→A ア→A),
              "Word(ことば)": %w(Noun1 Noun2)}
  end



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
