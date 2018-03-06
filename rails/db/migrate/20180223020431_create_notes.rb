class CreateNotes < ActiveRecord::Migration[5.1]
  def change
    create_table :notes do |t|
      t.string :code, null: false
      t.integer :owner_user_id, index: true, null: false
      t.string :title, null: false
      t.text :text, null: false, limit: 4294967295
      t.timestamps
    end

    add_index :notes, :code, unique: true
  end
end
