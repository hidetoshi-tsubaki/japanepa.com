class Community < ApplicationRecord
    has_many :community_users, dependent: :destroy
    has_many :users, through: :community_users
    accepts_nested_attributes_for :community_users
    has_many :talks, dependent: :destroy
    belongs_to :user
    mount_uploader :img, ImgUploader

    validates :name, uniqueness: { case_sensitive: false }

    # sort機能
    def self.sorted_by(sort) 
      case sort
      when 'most_posted'
        sorted_community_ids = Talk.group("community_id").order("count_id desc").count(:id).keys
        # postがゼロのものを後ろに追加する
        sorted_community_ids += Community.joins("LEFT OUTER JOIN talks ON communities.id = talks.community_id").where(talks: {community_id: nil}).pluck(:id)
        Community.find(sorted_community_ids)
      when 'most_members'
        sorted_community_ids =CommunityUser.group("community_id").order("count_id desc").count(:id).keys
        sorted_community_ids += Community.joins("LEFT OUTER JOIN community_users ON communities.id = community_users.community_id").where(community_users: {community_id:nil}).pluck(:id)
        Community.find(sorted_community_ids)
      when 'oldest'
        Community.all.order('created_at asc')
      else
        Community.all.order('created_at desc')
      end

      def self.search(keyword)
        render 'index' if params[:keyword] == ""

        keywords = params[:keyword].split(/[[:blank]]+/)
        @communities = []
        keywords.each do |keyword|
          next if keyword == ""
          @communities += Community.where('name LIKE? OR introduction LIKE?',"%#{keyword}%","%#{keyword}%")
        end
        @communities.uniq!
      end
  end
end
