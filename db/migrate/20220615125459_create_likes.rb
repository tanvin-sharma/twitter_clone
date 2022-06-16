class CreateLikes < ActiveRecord::Migration[7.0]
  def change
    create_table :likes do |t|
      t.references :user
      t.references :tweet
      t.timestamps
    end
  end
end
