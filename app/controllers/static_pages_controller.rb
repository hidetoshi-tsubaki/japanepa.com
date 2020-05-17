class StaticPagesController < ApplicationController
  before_action :admin_root
  before_action :get_unchecked_announce_count, :get_current_level

  def home
    get_unchecked_announce_count if user_signed_in?
  end

end
