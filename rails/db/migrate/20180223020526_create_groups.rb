class CreateGroups < ActiveRecord::Migration[5.1]
  def change
    create_table :groups do |t|
      t.integer :owner_user_id, index: true, null: false
      t.string :name, null: false
      t.timestamps
    end
  end
end
