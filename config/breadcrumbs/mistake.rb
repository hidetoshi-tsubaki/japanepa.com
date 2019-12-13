crumb :show_mistake do |quiz_category|
  link "Mistakes: #{quiz_category.name}", play_quiz_path(quiz_category)
  parent :quiz_categories
end