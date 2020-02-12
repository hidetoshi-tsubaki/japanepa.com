crumb :talks do
  link "talks", talks_path
end

crumb :show_talk do |talk|
  link "Talk - #{talk.id}", talk_path(talk)
  parent :talks
end

crumb :edit_talk do |talk|
  link "Edit Talk - #{talk.id}", edit_talk_path
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

crumb :admin_talk do |talk|
  link "Talk - #{talk.id}", admin_talks_path(talk)
  parent :admin_talks
end