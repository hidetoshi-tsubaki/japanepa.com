class AnnouncementsController < ApplicationController
  before_action :only_login_user!
  before_action :get_unchecked_announce_count, :get_not_done_reviews_count, only: :index
  impressionist :actions => [:show]

  def index
    @announcements = Announcement.sorted.limit(15)
  end

  def show
    @announce = Announcement.find(params[:id])
    current_user.check_announce(@announce) unless current_user.aleady_checked?(@announce)
  end
end
