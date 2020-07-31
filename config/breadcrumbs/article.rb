crumb :root do
  link "Home", root_path
end

crumb :articles do
  link "articles", articles_path
end

crumb :show_article do |article|
  link article.title, article_path(article)
  parent :articles
end

# Admin Article
crumb :admin_articles do
  link "Articles", admin_articles_path
end

crumb :edit_article do |article|
  link "Edit #{article.title[0..15]}", edit_admin_article_path
  parent :admin_articles
end

crumb :new_article do
  link "New article", new_admin_article_path
  parent :admin_articles
end