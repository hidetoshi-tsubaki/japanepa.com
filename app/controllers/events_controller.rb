class EventsController < ApplicationController
  before_action :only_login_user!
  impressionist :actions => [:show]

  def index
    @events = Event.where(status: true)
  end

  def show
    @event = Event.find(params[:id])
    p @event
  end
end
