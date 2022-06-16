class Tweet < ApplicationRecord
  validates :content, presence: true
  has_many :comments 
  belongs_to :user
  has_many :likes
  has_many :user_likes, class_name: 'User', through: :likes

end
