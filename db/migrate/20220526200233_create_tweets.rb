class CreateTweets < ActiveRecord::Migration[7.0]
  def change
    create_table :tweets do |t|
      t.string :content
      t.references :user
      t.timestamps
    end
  end
end
