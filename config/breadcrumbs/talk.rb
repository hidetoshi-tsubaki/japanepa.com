crumb :talks do
  link "Feed", feed_talks_path
end

crumb :edit_talk do |talk|
  link "Edit Talk - #{talk.id}", edit_talk_path
  parent :talks
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
