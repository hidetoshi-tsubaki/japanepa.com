module QuizCategoriesHelper
  def experience_array
    (0..25).map { |num| (1 + (num.to_d * 0.1)).floor(2) }
  end

  def form_title(parent)
    if parent.is_level?
      "Section 名"
    elsif parent.is_section?
      "Title 名"
    end
  end

  def get_category(category)
    if category.is_level?
      "Level 名"
    elsif category.is_section?
      "Section 名"
    elsif category.is_title?
      "Title 名"
    end
  end

  def title_index?(category)
    category.present? && category.is_title?
  end

  def get_learning_level(user, category)
    if learning_level = category.learning_levels.where(user_id: user.id).first
      learning_level.percentage
    end
  end

  def bar_color(user, category)
    case get_learning_level(user, category)
    when 0..29
      "red_bg"
    when 30..49
      "yellow_bg"
    when 50..79
      "blue_bg"
    when 80..99
      "green_bg"
    when 100
      "gold_bg"
    end
  end
end
