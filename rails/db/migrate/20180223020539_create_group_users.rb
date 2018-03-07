class CreateGroupUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :group_users do |t|
      t.integer :group_id, index: true, null: false
      t.integer :user_id, index: true, null: false
      t.timestamps
    end

    add_index :group_users, [:group_id, :user_id], unique: true
  end
end
