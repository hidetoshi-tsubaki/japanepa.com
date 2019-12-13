crumb :talks do
  link "talks", talks_path
end

crumb :show_talk do |talk|
  link talk.name, talk_path(talk)
  parent :talks
end

crumb :edit_talk do |talk|
  link "Edit #{talk.name}", edit_talk_path
  parent :show_talk, talk
end

crumb :new_talk do
  link "New talk", new_talk_path
  parent :talks
end

# Admin
crumb :admin_talks do
  link "talks", admin_talks_path
end