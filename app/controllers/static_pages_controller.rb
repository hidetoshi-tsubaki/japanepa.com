class StaticPagesController < ApplicationController
  before_action :admin_root

  def home
    @information = Information.where(status: true).sorted
  end

end
