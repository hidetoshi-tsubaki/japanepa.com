class User < ApplicationRecord
  has_many :community_users, dependent: :destroy
  has_many :communities ,through: :community_users
  has_many :score_records, dependent: :destroy
  has_many :talks, dependent: :destroy
  has_many :communities, dependent: :destroy
  has_many :comments,dependent: :destroy
  
  mount_uploader :img, ImgUploader
  validates :name, uniqueness: { case_sensitive: false }
  
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :confirmable, :lockable, :timeoutable, :omniauthable,omniauth_providers: [:facebook,:twitter,:google_oauth2]

  

  def self.from_omniauth(auth)
    find_or_create_by(provider: auth["provider"], uid: auth["uid"]) do |user|
      user.provider = auth["provider"]
      user.uid = auth["uid"]
      user.name = auth["info"]["nickname"]
    end
  end

  def self.new_with_session(params, session)
    if session["devise.user_attributes"]
      new(session["devise.user_attributes"]) do |user|
        user.attributes = params
      end
    else
      super
    end
  end

  def alradey_joined?(community)
    community_users.find_by(community_id: community.id)
  end

  def join(community)
    community_users.create!(community_id: community.id)
  end

  def leave(community)
    community_users.find_by(community_id: community.id).destroy
  end
end
