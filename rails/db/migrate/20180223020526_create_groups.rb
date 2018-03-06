class CreateGroups < ActiveRecord::Migration[5.1]
  def change
    create_table :groups do |t|
      t.string :code,  null: false
      t.integer :owner_user_id, index: true, null: false
      t.string :name, null: false
      t.timestamps
    end
    add_index :groups, :code, unique: true
  end
end
