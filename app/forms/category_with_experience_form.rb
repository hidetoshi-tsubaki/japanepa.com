class CategoryWithExperienceForm
  include ActiveModel::Model

  attr_accessor :name, :parent_id, :experience, :id

  validates :name, :parent_id, :experience, presence: true

  def save
    return false if invalid?
    @category = QuizCategory.new(name: name, parent_id: parent_id)
    @category.save
    @experience = experience
    quiz_experience = QuizExperience.new(title_id: @category.id, experience: @experience)
    quiz_experience.save
  end

  def update(category_params)
    @category = QuizCategory.find(id)
    @category.update(name: name)
    @category.save
    @quiz_experience = QuizExperience.find_by(title_id: @category.id)
    @quiz_experience.update(experience: experience)
    @quiz_experience.save
  end
end