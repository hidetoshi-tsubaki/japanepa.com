class EventsController < ApplicationController
  before_action :only_login_user!
  impressionist :actions => [:show]

  def index
    @events = Event.where(status: true)
  end

  def show
    @event = Event.find_by_id(params[:id])
    redirect_to root_path if @event.nil?
  end
end
