require "date"
namespace :counting do
  desc "日毎のデータ数を保存する"
  task :counting_date => :environment do

    user_count = User.count
    quiz_play_count = ScoreRecord.count
    article_view_count = Article.sum(:impressions_count)
    community_count = Community.count
    talk_count = Talk.count

    counting = Counting.new(
      users: user_count,
      quiz_play: quiz_play_count,
      article_views: article_view_count,
      communities: community_count,
      talks: talk_count
    )
    if counting.save
      number = Counting.count
      p "it was successed to Batch prosessing(batch No.#{number})"
    else
      number = Countig.count
      p "failed Batch prosessing failed（batch No.#{number+1}"
      counting.errors.full_messages.each_with_index do |message, index|
        p "#{index}: #{message}"
      end
    end
  end
end
