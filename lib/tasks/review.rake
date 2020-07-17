require "date"
namespace :review do
  desc "復習期限の切れたリマインドを消す"
  task :delete_overdue_reviews => :environment do

    Review.where("next_time < ?", Date.yesterday).destroy_all
    p "#########################"
    p "Delete overdued reviews"
    p "#########################"
  end
end