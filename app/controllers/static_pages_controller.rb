class StaticPagesController < ApplicationController
  before_action :admin_root

  def home
    get_unchecked_announce_count if user_signed_in?
  end

end
