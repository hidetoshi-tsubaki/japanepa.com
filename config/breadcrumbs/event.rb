crumb :root do
  link "Home", root_path
end

crumb :calendar do
  link "Calendar", events_path
end


# Admin Article
crumb :admin_events do
  link "Events", admin_events_path
end

crumb :admin_calendar do
  link "Calendar", calendar_admin_events_path
  parent :admin_events
end

crumb :edit_event do |event|
  link "Edit #{event.name}", edit_admin_event_path
  parent :admin_events
end

crumb :new_event do
  link "New event", new_admin_event_path
  parent :admin_events
end