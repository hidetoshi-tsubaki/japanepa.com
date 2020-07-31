class ScoreRecordsController < ApplicationController
  before_action :only_login_user!

  def create
    redirect_to quizzes_path if params[:score_record][:score].empty?
    current_user.score_records.create(save_score_record_params) unless played_mistakes?
    score_records = current_user.score_records.where(get_score_record_params).last(50).pluck(:score)
    create_mistakes_record
    update_learning_level(score_records)
    update_experience
    update_review_info
    get_user_level(current_user)
    respond_to do |format|
      format.js {
        render json: {
          score_records: score_records,
          current_level: @current_level,
          new_experience: @new_experience.floor,
          needed_experience: @needed_experience_to_next_level,
          learning_level: @percentage
        }
      }
    end
  end

  def index
    @levels = QuizCategory.includes(categories: :quizzes).levels
  end

  def show
    @quiz_category = QuizCategory.find(params[:id])
    @score_records = current_user.score_records.where(title_id: params[:id]).last(50).pluck(:score)
    @percentage = calculate_learning_level(@score_records)
    get_user_level
    respond_to do |format|
      format.js {
          render json: {
          score_records: @score_records,
          quiz_category: @quiz_category.name,
          needed_experience: @needed_experience_to_next_level,
          learning_level: @percentage
        }
      }
    end
  end

  private

  def save_score_record_params
    params.require(:score_record).permit(:score, :title_id)
  end

  def get_score_record_params
    params.require(:score_record).permit(:title_id)
  end

  def mistakes_params
    params.require(:score_record).permit(mistake_ids: [])
  end

  def played_mistakes?
    request.referer&.include?("play_mistakes")
  end

  def create_mistakes_record
    mistake_ids = mistakes_params[:mistake_ids]
    title_id = params[:score_record][:title_id]
    quiz_id = params[:score_record][:quiz_id]
    if mistake_ids.present?
      @mistakes = []
      mistake_ids.each do |id|
        miss = Mistake.find_or_initialize_by(quiz_id: id, user_id: current_user.id, title_id: title_id)
        if miss.new_record?
          @mistakes << miss
        else
          miss.count += 1
          @mistakes << miss
        end
      end
      Mistake.import @mistakes, on_duplicate_key_update: [:count] if @mistakes.present?
    end
  end

  def update_experience
    category = QuizCategory.includes(:quiz_experience).find(params[:score_record][:title_id])
    experience_rate = category.quiz_experience.rate
    if played_mistakes?
      @new_experience = calculate_experience(category)
    else
      @new_experience = BigDecimal(params[:score_record][:score]) * experience_rate
    end
    user_experience = UserExperience.find_by(user_id: current_user.id)
    user_experience.increment!(:total_point, @new_experience.to_i)
  end

  def calculate_experience(category)
    if correct_ids = params[:score_record][:correct_ids]
      quizzes_count = category.quizzes.length
      (correct_ids.length / quizzes_count.to_f * 100 * category.quiz_experience.rate).floor
    else
      0
    end
  end

  def calculate_learning_level(score_records)
    if score_records.length >= 5
      score_records[-5, 5].sum/5
    elsif score_records.length == 0
      0
    else
      score_records.sum/score_records.length
    end
  end

  def update_learning_level(score_records)
    @percentage = calculate_learning_level(score_records)
    learning_level = LearningLevel.find_or_initialize_by(title_id: params[:score_record][:title_id], user_id: current_user.id)
    if learning_level.new_record?
      learning_level.percentage = @percentage
      learning_level.save!
    else
      learning_level.update_attributes!(percentage: @percentage)
    end
  end

  def update_review_info
    review = Review.find_or_initialize_by(user_id: current_user.id, title_id: params[:score_record][:title_id])
    if review.new_record?
      review.save_as_new_record
    else
      review.overdue? ? review.reset_count : review.update_next_time_and_count
    end
  end
end
