crumb :root do
  link "Home", root_path
end

# Admin Comment
crumb :admin_comments do
  link "comments", admin_comments_path
end

crumb :admin_show_comment do |comment|
  link "comment - #{comment.id}", admin_comment_path(comment)
  parent :admin_comments
end
