module UsersHelper
  def add_emphasis(user)
    "emphasis_user" if user == current_user
  end

  def show_total_experience(user)
    user.user_experience.total_point
  end

  def is_top_3?(user_counter)
    case user_counter
    when 0
      "top_1"
    when 1
      "top_2"
    when 2
      "top_3"
    else
      "not_top_3"
    end
  end

  def current_rank
    UserExperience.where('total_point > ?', current_user.user_experience.total_point).count + 1
  end
end
