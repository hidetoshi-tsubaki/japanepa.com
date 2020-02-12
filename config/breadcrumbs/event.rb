crumb :root do
  link "Home", root_path
end

crumb :events do
  link "events", events_path
end


# Admin Article
crumb :admin_events do
  link "events", admin_events_path
end

crumb :edit_event do |event|
  link "Edit #{event.name}", edit_admin_event_path
  parent :admin_events
end

crumb :new_event do
  link "New event", new_admin_event_path
  parent :admin_events
end