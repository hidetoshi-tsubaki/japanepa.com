class Admin::StaticPagesController < ApplicationController
    before_action :authenticate_admin!

  def home
    @events = Event.where(status: true)
    @anouncement = Announcement.where(status: true)
  end
end
