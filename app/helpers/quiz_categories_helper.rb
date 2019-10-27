module QuizCategoriesHelper

  def experience_array
    (0..25).map{|num| (1 + (num.to_d * 0.1)).floor(2)}
  end
end
