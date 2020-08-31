crumb :admin_quizzes do
  link "quizzes", admin_quizzes_path
end

crumb :edit_quiz do |quiz|
  link "Edit #{quiz.question}", edit_admin_quiz_path
  parent :admin_quizzes
end

crumb :new_quiz do
  link "New Quiz", new_admin_quiz_path
  parent :admin_articles
end
