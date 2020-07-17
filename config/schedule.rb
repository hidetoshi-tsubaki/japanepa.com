require File.expand_path(File.dirname(__FILE__) + '/environment')
rails_env = ENV['RAILS_ENV'] || :development
set :environment, rails_env
set :output, "#{Rails.root}/log/cron.log"

# every 1.day, :at => '0am' do
#   rake 'counting:counting_date'
# end

# every 1.day, :at => '0am' do
every 1.minute do
  rake 'counting:counting_date'
  rake 'review:delete_overdue_reviews'
end

