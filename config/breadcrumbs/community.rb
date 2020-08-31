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
