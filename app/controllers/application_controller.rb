class ApplicationController < ActionController::Base
<<<<<<< HEAD
  include SessionsHelper
  protect_from_forgery with: :exception

  @n5Quiz= [{"Character(もじ)": %w(あ→A ア→A)},
            {"Word(ことば)": %w(Noun1 Noun2)}]

   # @n5Quiz= ["Character(もじ)": %w(あ→A ア→A あ→ア ア→あ A→あ A→ア),
    #           "Word(ことば)": %w(Noun1 Noun2 Noun3 Noun4 Noun5 Time1 Time2 Verb1 Verb2 Adjective1 Adjective2 Interrogative),
    #           "Kanji(かんじ)": %w(part1 part2 part3 part4 part5)]

=======
  protect_from_forgery with: :exception
>>>>>>> origin/master
end
