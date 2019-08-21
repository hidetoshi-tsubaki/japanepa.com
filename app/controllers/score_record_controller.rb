class ScoreRecordController < ApplicationController
  def create
    score_record = ScoreRecord.new(save_score_record_params)
    unless score_record.save
      flash.now[:notice] = "score could not saved. please try again .Or please tell us this error"
    end
    # chart用の配列を返す
    gon.score_record = ScoreRecord.where(get_score_record_params).last(50).pluck(:score)
    respond_to do |format|
      format.js { render json: gon.score_record }
    end
  end

  def index
    # chart.jsでcanvasのidを指定するため
    @n5_Quiz = { "Character(もじ)": %w(あ→A ア→A), "Word(ことば)": %w(Noun1 Noun2) }
    @score_Records = {}
    @n5_Quiz.each |section, titles|
      @scoreRecords.store(section, [])
        titles.each { |title|
        scoreArr = ScoreRecord.where(user_id: current_user.id, quizTitle: "#{title}").last(75).pluck(:score)
        @scoreRecords[section].push({ quizTitle: title, score: scoreArr })
      }
    end
    gon.scoreRecords = @score_Records
  end

  def show
    gon.user_id = current_user.id
  end

  private

  def save_score_record_params
    params.require(:score_record).permit(:score, :quizTitle, :user_id)
  end

  def get_score_record_params
    params.require(:score_record).permit(:quizTitle, :user_id)
  end
end
