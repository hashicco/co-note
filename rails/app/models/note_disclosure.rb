class NoteDisclosure < ApplicationRecord
  belongs_to :note
  belongs_to :group

  validates :note_id, :uniqueness => {:scope => :group_id}
  validates :group_id, :uniqueness => {:scope => :note_id}

end
