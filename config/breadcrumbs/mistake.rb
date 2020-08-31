crumb :show_mistake do |quiz_category|
  link "Mistakes: #{quiz_category.name}", quiz_play_path(quiz_category)
  parent :quiz_categories
end
