class CreateRelationships < ActiveRecord::Migration[6.1]
  def change
    create_table :relationships do |t|
      t.integer :follower_id  # フォローするユーザのid
      t.integer :followed_id  # フォローされるユーザのid
      t.integer :user_id
      t.string :type          # 非同期化に使用

      t.timestamps
    end
  end
end
