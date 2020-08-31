class User < ApplicationRecord
  has_many :community_users, dependent: :destroy
  has_many :communities, through: :community_users
  has_many :score_records, dependent: :destroy
  has_many :own_talks, class_name: 'Talk', foreign_key: 'user_id', dependent: :destroy
  has_many :founded_communities, class_name: 'Community', foreign_key: 'founder_id', dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :like_talks, dependent: :destroy
  has_many :talks, through: :like_talks
  has_many :talks, dependent: :destroy
  has_many :like_articles, dependent: :destroy
  has_many :articles, through: :like_articles
  has_many :bookmarks, dependent: :destroy
  has_many :articles, through: :bookmarks
  has_many :mistakes
  has_many :announcement_checks, dependent: :destroy
  has_many :learning_levels, dependent: :destroy
  has_many :masters, dependent: :destroy
  has_many :quiz_categories, through: :master
  has_many :reviews, dependent: :destroy
  has_one :user_experience, dependent: :destroy
  has_one_attached :img
  validates :name, uniqueness: { case_sensitive: false }
  validates :name, presence: true
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :lockable, :timeoutable, :omniauthable,
         omniauth_providers: [:facebook, :twitter]

  def update_without_current_password(params, *options)
    params.delete(:current_password)
    if params[:password].blank? && params[:password_confirmation].blank?
      params.delete(:password)
      params.delete(:password_confirmation)
    end
    result = update_attributes(params, *options)
    clean_up_passwords
    result
  end

  def self.from_omniauth(auth)
    find_or_initialize_by(provider: auth["provider"], uid: auth["uid"]) do |user|
      user.provider = auth["provider"]
      user.uid = auth["uid"]
      user.name = auth["info"]["name"]
      user.password = Devise.friendly_token[0, 20]
    end
  end

  def is_founder?(community)
    id == community.founder_id
  end

  def email_required?
    false
  end

  def email_changed?
    false
  end

  def get_learning_level(category)
    learning_levels.where(title_id: category.id).first.percentage
  end

  def already_mastered?(title)
    masters.find_by(title_id: title)
  end

  def master(title)
    masters.create!(title_id: title)
  end

  def not_mastered(title)
    return unless already_mastered?(title)
    masters.find_by(title_id: title).destroy
  end

  def already_joined?(community)
    community_users.find_by(community_id: community.id)
  end

  def join(community)
    community_users.create!(community_id: community.id)
  end

  def leave(community)
    community_users.find_by(community_id: community.id).destroy
  end

  def already_liked_talk?(talk)
    like_talks.find_by(talk_id: talk.id)
  end

  def like_talk(talk_id)
    like_talks.create!(talk_id: talk_id)
  end

  def remove_like_talk(talk_id)
    like_talks.find_by(talk_id: talk_id).destroy
  end

  def already_liked_article?(article)
    like_articles.find_by(article_id: article.id)
  end

  def like_article(article)
    like_articles.create!(article_id: article.id)
  end

  def remove_like_article(article)
    like_articles.find_by(article_id: article.id).destroy
  end

  def already_bookmark?(article)
    bookmarks.find_by(article_id: article.id)
  end

  def bookmark(article)
    bookmarks.create!(article_id: article.id)
  end

  def remove_bookmark(article)
    bookmarks.find_by(article_id: article.id).destroy
  end

  def aleady_checked?(announce)
    announcement_checks.find_by(announcement_id: announce.id)
  end

  def check_announce(announce)
    announcement_checks.create!(announcement_id: announce.id)
  end

  def reviews_today
    reviews.includes(:category).where(next_time: Date.yesterday..Date.today)
  end

  def coming_reviews
    reviews.includes(:category).where("next_time > ?", Date.today)
  end

  def reviews_done_today
    reviews.includes(:category).where(updated_at: Date.today.all_day).where("count > 1")
  end

  def have_overdue_review?
    reviews.find_by("next_time < ?", Date.today.prev_day(2))
  end

  def overdue_reviews
    reviews.where(count: 0).order(count: "ASC")
  end

  def reset_all_overdue_reviews
    reviews = []
    Review.where("user_id: self.id, next_time < ?", Date.today.prev_day(2)).each do |review|
      review.count = 0
      review.next_time = nil
      reviews << review
    end
    review.import reviews, on_duplicate_key_update: [:count, :next_time]
  end
end
