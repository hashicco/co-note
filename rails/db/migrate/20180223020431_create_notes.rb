class CreateNotes < ActiveRecord::Migration[5.1]
  def change
    create_table :notes do |t|
      t.integer :owner_user_id, index: true, null: false
      t.text :text
      t.boolean :disclosed_to_public, null: false, default: false

      t.timestamps
    end
  end
end
