class Talk < ApplicationRecord
  has_many :comments, dependent: :destroy
  has_many :like_talks, dependent: :destroy
  has_many :users, through: :like_talks
  has_one_attached :img
  belongs_to :user
  counter_culture :user, column_name: 'talk_count'
  belongs_to :community
  counter_culture :community, column_name: 'talk_count'

  validates :content, :user_id, :community_id, presence: true
  validate :image_content_type, if: :was_attached?
  
  scope :in_joined_communities, -> (user) do
    includes(:user, [community: :community_users]).
    where(community_users: { user_id: user.id }).
    with_attached_img.
    sorted
  end

  scope :commented_top_3, -> { includes(:user).with_attached_img.order(likes_count: :desc).limit(3) }
  scope :liked_top_3, -> { with_attached_img.order(comments_count: :desc).limit(3) }
end
