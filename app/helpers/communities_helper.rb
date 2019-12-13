module CommunitiesHelper
  def past_30days_after_signIn?
    past_days = (Time.now - current_user[:created_at]).floor / 60 / 60 / 24
    past_days >= 30 || current_user.id  < 3
  end

  def is_founder(comunity)
    true if current_user.id == community.founder_id
  end
end
