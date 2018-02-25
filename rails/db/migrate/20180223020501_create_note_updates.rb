class CreateNoteUpdates < ActiveRecord::Migration[5.1]
  def change
    create_table :note_updates do |t|
      t.integer :note_id, index: true, null: false
      t.text :text, null: false
      t.string :status, null: false, default: :WAITING

      t.timestamps
    end
  end
end
