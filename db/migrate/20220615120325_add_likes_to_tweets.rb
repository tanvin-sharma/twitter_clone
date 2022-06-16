class AddLikesToTweets < ActiveRecord::Migration[7.0]
  def change
    add_column :tweets, :no_of_likes, :integer, null: false, default: 0
  end
end