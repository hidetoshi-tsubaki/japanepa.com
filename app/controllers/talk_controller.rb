class TalkController < ApplicationController
  
  before_action :authenticate_user!

  def new
    # @talk = Talk.new
    # @talks = Talk.where(user_id: current_user.id)
    # pry-byebug 
  end
  
  def index
    @talk = Talk.new
    @talks = Talk.where(user_id: current_user.id).order('created_at DESC')
  end

  def show
  end

  def create
    @user = User.find(current_user.id)
    @talk = @user.talk.new(talk_params)
    if @talk.save
      flash.now[:notice]="talk was post"
      p flash[:notice]
      @talks = Talk.where(user_id: current_user.id).order('created_at DESC')
      render :index
    end    
  end

  private

    def talk_params
      params.require(:talk).permit(:content, :img,:remove_img)
    end


end
