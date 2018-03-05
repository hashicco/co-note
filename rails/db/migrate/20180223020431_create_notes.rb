class CreateNotes < ActiveRecord::Migration[5.1]
  def change
    create_table :notes do |t|
      t.integer :owner_user_id, index: true, null: false
      t.string :title, null: false
      t.text :text, null: false
      t.timestamps
    end
  end
end
