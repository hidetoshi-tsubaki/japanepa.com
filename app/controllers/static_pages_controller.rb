class StaticPagesController < ApplicationController
  before_action :admin_root

  def home
    @events = Event.where(status: true)
    @information = Information.where(status: true).sorted
  end

end
