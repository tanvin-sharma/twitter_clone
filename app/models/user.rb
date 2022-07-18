class User < ApplicationRecord
  has_secure_password
  validates :name, presence: true, uniqueness: true
  validates :handle, presence: true, uniqueness: true
  validates :email, presence: true, uniqueness: true
  validates_format_of :email, with: URI::MailTo::EMAIL_REGEXP
  has_many :tweets
  has_many :likes 
  has_many :comments

end
