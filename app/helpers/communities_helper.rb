module CommunitiesHelper
  def past_30days_after_signIn?
    past_days = (Time.now - current_user[:created_at]).floor / 60 / 60 / 24
    past_days >= 30 || current_user.id  < 3
  end

  def initial_color(community)
    if community.id % 4 == 0
      "initial_red"
    elsif community.id % 3 == 0
      "initial_blue"
    elsif community.id % 2 == 0
      "initial_green"
    else
      "initial_orange"
    end
  end
end
