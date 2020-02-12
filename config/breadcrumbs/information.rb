crumb :information_index do
  link "information", information_index_path
end

crumb :show_info do |info|
  link info.title, information_path(info)
end

crumb :admin_information_index do
  link "Information", admin_information_index_path
end

crumb :new_information do
  link "NEW info", new_admin_information_path
  parent :admin_information_index
end

crumb :show_info do |info|
  link info.title, admin_information_path(info)
end

crumb :edit_information do |info|
  link "Edit #{info.title}", edit_admin_information_path
  parent :admin_information_index
end