class AnnouncementsController < ApplicationController
  before_action :only_login_user!
  before_action :get_unchecked_announce_count, :get_not_done_reviews_count, only: [:index, :show]
  impressionist :actions => [:show]

  def index
    @announcements = Announcement.published
  end

  def show
    @announce = Announcement.find(params[:id])
    current_user.check_announce(@announce) unless current_user.aleady_checked?(@announce)
  end
end
