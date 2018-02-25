class CreateNoteUpdates < ActiveRecord::Migration[5.1]
  def change
    create_table :note_updates do |t|

      t.timestamps
    end
  end
end
