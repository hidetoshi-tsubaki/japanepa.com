crumb :root do
  link "Home", root_path
end

crumb :quiz_categories do
  link "Quizzes", quizzes_path
end

crumb :admin_quizzes do
  link "Quizzes", admin_quizzes_path
end

crumb :show_category do |quiz_category|
  link quiz_category.name, play_quiz_path(quiz_category)
  parent :quiz_categories
end