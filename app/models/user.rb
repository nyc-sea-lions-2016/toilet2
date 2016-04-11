class User < ActiveRecord::Base
  before_save { self.email = email.downcase }

  has_secure_password

  has_many :favorites, foreign_key: 'favoriter_id'
  has_many :favorite_toilets, through: :favorites, source: 'toilets'
  has_many :reviews, foreign_key: 'reviewer_id'
  has_many :reviewed_toilets, through: :reviews, source: 'toilets'

  validates :username, {presence: true, uniqueness: true, length: { maximum: 50 }}
  validates :password, presence: true, length: { minimum: 6 }, allow_nil: true
  validates :email, :first_name, :last_name, :zip_code, :gender, {presence: true}
  validates_format_of :email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i
end
