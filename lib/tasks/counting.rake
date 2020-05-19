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
    time = Time.now
    if counting.save
      p "successed to Batch prosessing(#{time})"
    else
      p "***********************************************************"
      p "  failed Batch prosessing failed（#{time}) "
      p "***********************************************************"
      p ""
      p "----------error messages------------"
      counting.errors.full_messages.each_with_index do |message, index|
        p "#{index}: #{message}"
      end
      p "------------------------------------"
    end
  end
end
