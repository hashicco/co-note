class User < ApplicationRecord
  has_many :groups, foreign_key: :owner_user_id
  has_many :group_users
  has_many :included_groups, through: :group_users, source: :group

  has_many :notes, foreign_key: :owner_user_id

  validates :email, uniqueness: true, presence: true
  validates :name, presence: true

  def add_user_to(group, user)
    add_user_to!(group, user)
    true
  rescue => e
    return false
  end

  def add_user_to!(group, user)
    raise unless group.owned_by?(self)
    raise if group.include?(user)
    raise if self == user

    group.add_user! user
  end

  def remove_user_from(group, user)
    remove_user_from!(group, user)
    true
  rescue => e
    return false
  end

  def remove_user_from!(group, user)
    raise unless group.owned_by?(self)
    raise unless group.include?(user)

    group.remove_user! user
  end

  def disclosed_or_own_notes
    Note.disclosed_to_or_owned_by(self)
  end

  def disclose_note_to!(group, note)
    raise unless note.owned_by?(self)
    raise unless group.owned_by?(self)
    note.disclose_to!(group)
  end

  def enclose_note_from!(group, note)
    raise unless note.owned_by?(self)
    raise unless group.owned_by?(self)
    note.enclose_from!(group)
  end

end
