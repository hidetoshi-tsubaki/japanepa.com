module QuizCategoriesHelper

  def experience_array
    (0..25).map{|num| (1 + (num.to_d * 0.1)).floor(2)}
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
end
