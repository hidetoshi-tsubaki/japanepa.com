class Community < ApplicationRecord
    has_many :community_users, dependent: :destroy
    has_many :users, through: :community_users
    accepts_nested_attributes_for :community_users
    has_many :talks, dependent: :destroy
    belongs_to :user
    mount_uploader :img, ImgUploader

    validates :name, uniqueness: { case_sensitive: false }

    # sort機能
    def self.sorted_by(key) 
      case key
      when 'Posts - Descending'
        sorted_community_ids = Talk.group("community_id").order("count_id desc").count(:id).keys
        # postがゼロのものを後ろに追加する
        sorted_community_ids += Community.joins("LEFT OUTER JOIN talks ON communities.id = talks.community_id").where(talks: {community_id: nil}).pluck(:id)
        Community.find(sorted_community_ids)
      when 'Posts - Ascending'
        sorted_community_ids = Community.joins("LEFT OUTER JOIN talks ON communities.id = talks.community_id").where(talks: {community_id: nil}).pluck(:id)
        sorted_community_ids += Talk.group("community_id").order("count_id asc").count(:id).keys
        a = Community.find(sorted_community_ids)
      when 'Members - Descending'
        sorted_community_ids = CommunityUser.group("community_id").order("count_id desc").count(:id).keys
        # sorted_community_ids += Community.joins("LEFT OUTER JOIN community_users ON communities.id = community_users.community_id").where(community_users: {community_id:nil}).pluck(:id)
        Community.find(sorted_community_ids)
      when 'Members - Ascending'
        sorted_community_ids = CommunityUser.group("community_id").order("count_id asc").count(:id).keys
        # sorted_community_ids += Community.joins("LEFT OUTER JOIN community_users ON communities.id = community_users.community_id").where(community_users: {community_id:nil}).pluck(:id)
        Community.find(sorted_community_ids)
      when 'Date - new to old'
        Community.all.order('created_at desc')
      when 'Date - old to new'
        Community.all.order('created_at asc')
      else
        Community.all.order('created_at desc')
      end
    end

    def self.search(keywords_params)
    return communities = Community.all.order('created_at desc') if keywords_params == ""
    keywords = keywords_params.split(/[[:blank:]]+/)
    p keywords
    communities = []
    keywords.each do |keyword|
      next if keyword == ""
      communities += Community.where('name LIKE ? OR introduction LIKE ?',"%#{keyword}%","%#{keyword}%")
    end
    # uniq!だと、変更がないとnilを返してしまう
    communities = communities.uniq
    end

end
