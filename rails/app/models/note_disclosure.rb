class NoteDisclosure < ApplicationRecord
  belongs_to :note, dependent: :destroy
  belongs_to :group, dependent: :destroy

  validates :note_id, :uniqueness => {:scope => :group_id}
  validates :group_id, :uniqueness => {:scope => :note_id}

end
