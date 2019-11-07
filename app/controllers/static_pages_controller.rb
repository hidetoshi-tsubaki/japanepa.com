class StaticPagesController < ApplicationController
  def home
  end
  
  def feed
    @talks = Talk.in_joined_communities(current_user)
    @tags = Community.tags_on(:tags)
  end
end
