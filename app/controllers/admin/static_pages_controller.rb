class Admin::StaticPagesController < ApplicationController
  before_action :authenticate_admin!

  def home
    @countings = %w(users quiz_play article_views communities talks)
    gon.users_counting = Counting.pluck(:users)
    gon.quiz_play_counting = Counting.pluck(:quiz_play)
    gon.article_views_counting = Counting.pluck(:article_views)
    gon.communities_counting = Counting.pluck(:communities)
    gon.talks_counting = Counting.pluck(:talks)
  end
end
