require 'date'
require 'csv'

class FindLikesJob < ApplicationJob
  queue_as :default

  def perform(user_id, ts_from, ts_to)
    user = User.find(user_id)
    start_date, end_date = Date.parse(ts_from), Date.parse(ts_to)
    likes = Like.where(tweet:  user.tweets, created_at: (start_date..end_date))
    CSV.open("./likes_report.csv", 'w+') do |add|
      (start_date..end_date).each do |date|
        like_count = likes.where(created_at: (date.beginning_of_day..date.end_of_day)).count
        add << [date.strftime("%d/%m/%Y"), like_count] 
      end
    end
  end
end 