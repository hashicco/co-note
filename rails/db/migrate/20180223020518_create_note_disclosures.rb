class CreateNoteDisclosures < ActiveRecord::Migration[5.1]
  def change
    create_table :note_disclosures do |t|
      t.integer :note_id, index: true, null: false
      t.integer :group_id, index: true, null: false
      t.timestamps
    end
  end
end
