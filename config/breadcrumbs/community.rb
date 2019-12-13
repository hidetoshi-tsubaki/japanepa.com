crumb :root do
  link "Home", root_path
end

crumb :communities do
  link "communities", communities_path
end

crumb :show_community do |community|
  link community.name, community_path(community)
  parent :communities
end

crumb :edit_community do |community|
  link "Edit #{community.name}", edit_community_path
  parent :show_community, community
end

crumb :new_community do
  link "New community", new_community_path
  parent :communities
end

# Admin
crumb :admin_communities do
  link "Communities", admin_communities_path
end

# crumb :project_issues do |project|
#   link "Issues", project_issues_path(project)
#   parent :project, project
# end

# crumb :issue do |issue|
#   link issue.title, issue_path(issue)
#   parent :project_issues, issue.project
# end

# If you want to split your breadcrumbs configuration over multiple files, you
# can create a folder named `config/breadcrumbs` and put your configuration
# files there. All *.rb files (e.g. `frontend.rb` or `products.rb`) in that
# folder are loaded and reloaded automatically when you change them, just like
# this file (`config/breadcrumbs.rb`).