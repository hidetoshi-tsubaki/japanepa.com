module UsersHelper
  def add_emphasis(user)
    "emphasis_user" if user == current_user
  end

  def show_total_experience(user)
    user.user_total_experiences.first.total_experience
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
end