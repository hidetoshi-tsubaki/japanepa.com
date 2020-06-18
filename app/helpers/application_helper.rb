module ApplicationHelper
  require "uri"

  def text_url_to_link(text)
    URI.extract(text, ['http', 'https']).uniq.each do |url|
      sub_text = ""
      sub_text << "<a href=" << url << " target=\"_blank\">" << url << "</a>"
      text.gsub!(url, sub_text)
    end
    text
  end

  def month_ago?(announce)
    today = Date.today
    announce.created_at > today.prev_month
  end

  def contents_status(contents)
    contents.published? ? "eye" : "eye-slash"
  end

  def updated?(article)
    article.created_at == article.updated_at ? article.created_at : article.updated_at
  end

  def header_color
    case controller.controller_name
    when "articles"
      "articles_header"
    when "quizzes"
      "quizzes_header"
    when "communities"
      "communities_header"
    when "talks"
      "talks_header"
    when "users"
      "users_header"
    else
      "home_header"
    end
  end

  def own_profile?(user)
    current_user.id == user.id
  end

  def own_post?(post)
    current_user.id == post.user_id
  end

  def top_3(counter)
    case counter
    when 0
      "gold_bg"
    when 1
      "silver_bg"
    when 2
      "bronze_bg"
    end
  end

  def thumbnails_color(article)
    if article.id % 5 == 0
      "yellow_bg"
    elsif article.id % 4 == 0
      "green_bg"
    elsif article.id % 3 == 0
      "orange_bg"
    elsif article.id % 2 == 0
      "red_bg"
    else
      "blue_bg"
    end
  end

  def community_page?
    controller.controller_name == "communtiy"
  end

end
