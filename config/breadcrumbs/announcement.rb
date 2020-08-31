crumb :announcements_index do
  link "announcements", announcements_path
end

crumb :show_announcement do |announce|
  link announce.title, new_admin_announcement_path
  parent :announcements_index
end

# admin
crumb :admin_announcements_index do
  link "announcements", admin_announcements_path
end

crumb :new_announcement do
  link "NEW announcement", new_admin_announcement_path
  parent :admin_announcements_index
end

crumb :edit_announcement do |announce|
  link "Edit #{announce.title}", edit_admin_announcement_path
  parent :admin_announcements_index
end
