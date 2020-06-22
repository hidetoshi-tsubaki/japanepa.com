crumb :root do
  link "Home", root_path
end

crumb :users do
  link "ranking", ranking_path
end

crumb :show_user do |user|
  link user.name, user_path(user)
  parent :users
end

crumb :edit_user do |user|
  link "Edit Profile", edit_user_registration_path
  parent :show_user, user
end

crumb :new_user do
  link "Register", new_user_registration_path
end

crumb :login do
  link "Log In"
end

# Admin
crumb :admin_users do
  link "users", admin_users_path
end