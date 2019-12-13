crumb :quizzes do
  link "Quizzes", quizzes_path
end

crumb :admin_quizzes do
  link "Quizzes", admin_quizzes_path
end

crumb :play_quiz do |quiz|
  link quiz.quiz_category.name, play_quiz_path(quiz)
  parent :quizzes
end

crumb :play_mistake_quiz do |quiz|
  link article.title, play_mistakes_quiz_path(quiz)
  parent :quizzes
end

# Admin Article
crumb :admin_quizzes do
  link "quizzes", admin_quizzes_path
end

crumb :edit_quiz do |quiz|
  link "Edit #{quiz.question}", edit_admin_article_path
  parent :admin_articles
end

crumb :new_quiz do
  link "New Quiz", new_admin_quiz_path
  parent :admin_articles
end