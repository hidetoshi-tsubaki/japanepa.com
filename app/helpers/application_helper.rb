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

  def month_ago?(info)
    today = Date.today
    info.created_at > today.prev_month
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
end
