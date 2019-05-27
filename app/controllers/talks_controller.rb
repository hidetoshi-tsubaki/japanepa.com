class TalksController < ApplicationController
  before_action :authenticate_user!, only:[:create,:delete,]

  def new
    # @talk = Talk.new
    # @talks = Talk.where(user_id: current_user.id)
    # pry-byebug 
  end
  
  def index
    @talk = Talk.new
    @talks = Talk.where(user_id: current_user.id).order('created_at DESC')
    @action = "Post"
  end

  def show
  end

  def create
    # @user = User.find(current_user.id)
    @talk = current_user.talk.new(talk_params)
    if @talk.save
      flash.now[:notice]="talk was post"
      @talks = Talk.where(user_id: current_user.id).order('created_at DESC')
      @talk = Talk.new
      render :index
    end    
  end

  def edit
    @talk = Talk.find(params[:id])
    @action="Save"
    render :form_talk
    flash.now[:notice]="talk was saved"
  end

  def delete
    Talk.find(params[:id]).destroy
    @talks = Talk.where(user_id: current_user.id).order('created_at DESC')
    render :index
  end

  private

    def talk_params
      params.require(:talk).permit(:content, :img,:remove_img)
    end

end
