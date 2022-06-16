class AddIndexToLike < ActiveRecord::Migration[7.0]
  def change
    add_index :likes, [:user_id, :tweet_id]
  end
end
