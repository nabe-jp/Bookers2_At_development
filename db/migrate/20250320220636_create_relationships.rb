class CreateRelationships < ActiveRecord::Migration[6.1]
  def change
    create_table :relationships do |t|
      t.integer :follower_id  # フォローするユーザのid
      t.integer :followed_id  # フォローされるユーザのid
      t.integer :user_id

      t.timestamps
    end
  end
end