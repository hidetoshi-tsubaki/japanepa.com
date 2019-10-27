class TitleQuizExperienceForm
  include ActiveModel::Model

  attr_accessor :name, :parent_id, :experience

  validates :name, :parent_id, :experience, presence: true

  def save
    return false if invalid?
    @category = QuizCategory.new(name: name, parent_id: parent_id)
    @category.save
    @experience = experience
    quiz_experience = QuizExperience.new(title_id: @category.id, experience: @experience)
    quiz_experience.save!
  end
end