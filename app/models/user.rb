class User < ApplicationRecord
  validates :name, presence: true, uniqueness: true
  validates :handle, presence: true, uniqueness: true
  validates :email, presence: true, uniqueness: true
  has_many :tweets
  has_many :likes 
  has_many :comments

end
