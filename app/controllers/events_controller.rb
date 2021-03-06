class EventsController < ApplicationController
  before_action :only_login_user!
  before_action :get_unchecked_announce_count,
                :get_not_done_reviews_count,
                only: :index
  impressionist :actions => [:show]

  def index
    @events = Event.where(status: true)
  end

  def show
    @event = Event.find(params[:id])
  end
end
