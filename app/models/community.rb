class Community < ApplicationRecord
  acts_as_taggable
  has_many :community_users, dependent: :destroy
  has_many :users, through: :community_users
  accepts_nested_attributes_for :community_users
  has_many :talks, dependent: :destroy
  belongs_to :founder, class_name: 'User', foreign_key: 'founder_id'
  has_one_attached :img
  # validate :img_presence
  validate :image_content_type, if: :was_attached?
  validates :name, uniqueness: { case_sensitive: false }
  validates :name, :introduction, :founder_id, presence: true

end
