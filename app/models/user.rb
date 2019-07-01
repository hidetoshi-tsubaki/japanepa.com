class User < ApplicationRecord
  has_many :community_users, dependent: :destroy
  has_many :communities ,through: :community_users
  has_many :score_records, dependent: :destroy
  has_many :talks, dependent: :destroy
  has_many :communities, dependent: :destroy
  has_many :comments,dependent: :destroy
  # has_many :like_posts, dependent: :destroy
  # has_many :talks , through: :like_posts
  has_many :like_talks, dependent: :destroy
  has_many :talks, through: :like_talks
  has_many :like_articles, dependent: :destroy
  has_many :articles, through: :like_articles
  has_many :bookmarks ,dependent: :destroy
  has_many :articles, through: :bookmarks
  
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

  # join community
  def already_joined?(community)
    community_users.find_by(community_id: community.id)
  end

  def join(community)
    community_users.create!(community_id: community.id)
  end

  def leave(community)
    community_users.find_by(community_id: community.id).destroy
  end

  # like talk
  def already_liked_talk?(talk)
    like_talks.find_by(talk_id: talk.id)
  end

  def like_talk(talk)
    like_talks.create!(talk_id: talk.id)
  end

  def remove_like_talk(talk)
    like_talks.find_by(talk_id: talk.id).destroy
  end

  #like article
  def already_liked_article?(article)
    like_articles.find_by(article_id: article.id)
  end

  def like_article(article)
    like_articles.create!(article_id: article.id)
  end

  def remove_like_article(article)
    like_articles.find_by(article_id: article.id).destroy
  end

  #bookmark article
  def already_bookmark?(article)
    bookmarks.find_by(article_id: article.id)
  end

  def bookmark(article)
    bookmarks.create!(article_id: article.id)
  end

  def remove_bookmark(article)
    bookmarks.find_by(article_id: article.id).destroy
  end
end
