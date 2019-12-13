class ScoreRecordsController < ApplicationController
  before_action :authenticate_user!

  def create
    score_record = current_user.score_records.new(save_score_record_params)
    score_record.save! unless request.referer&.include?("play_mistakes")
    score_record = current_user.score_records.where(get_score_record_params).last(50).pluck(:score)
    create_mistakes_record
    update_experience
    get_user_level
    respond_to do |format|
      format.js {
        render json: {
          score_record: score_record,
          current_level: @current_level,
          next_level: @next_level,
          new_experience: @new_experience,
          needed_experience: @needed_experience_to_next_level }
      }
    end
  end

  def index
    @levels = QuizCategory.includes(categories: :quizzes).levels
  end

  def show
    @quiz_category = QuizCategory.find(params[:id])
    @score_record = current_user.score_records.where(title_id: params[:id]).last(50).pluck(:score)
    get_user_level
    respond_to do |format|
      format.js { 
        render json: {
          score_record: @score_record,
          quiz_category: @quiz_category,
          current_level: @current_level,
          next_level: @next_level,
          needed_experience: @needed_experience_to_next_level
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
          p "new"
        else
          p "add"
          miss.count += 1
          @mistakes << miss
        end
      end
      Mistake.import @mistakes, on_duplicate_key_update: [:count] if @mistakes.present?
    end
  end

  def update_experience
    category = QuizCategory.includes(:quiz_experiences).find(params[:score_record][:title_id])
    quiz_experience = category.quiz_experiences.first
    @new_experience = params[:score_record][:score] * quiz_experience.experience
    user_experience = UserTotalExperience.find_by(user_id: current_user.id)
    user_experience.increment!(:total_experience, @new_experience.to_i)
  end

end
