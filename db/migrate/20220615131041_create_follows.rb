class CreateFollows < ActiveRecord::Migration[7.0]
  def change
    create_table :follows do |t|
      t.references :user_id
      t.integer :follower_id, null: false
      t.timestamps
    end
  end
end