class StaticPagesController < ApplicationController
  before_action :admin_root
  before_action :get_current_level

  def home
    if user_signed_in?
      get_unchecked_announce_count
      get_not_done_reviews_count
    end
  end

end
