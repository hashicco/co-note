class Group < ApplicationRecord
  belongs_to :owner, foreign_key: :owner_user_id, class_name: "User"
  has_many :group_users
  has_many :including_users, through: :group_users, source: :user
  accepts_nested_attributes_for :group_users, reject_if: ->(attrs){ attrs['user_id'].blank? }, allow_destroy: true

  has_many :disclosures, class_name: "NoteDisclosure"
  has_many :disclosed_notes, through: :disclosures, source: :note

  scope :including_user, ->(user){
    joins(:group_users).where(:group_users => {user_id: user.id} )
  }

  scope :owned_by, ->(user){
    where(owner_user_id: user.id)
  }

  def owned_by?(user)
    owner == user
  end

  def include?(user)
    group_users.where(user: user).any?
  end

  def add_user(user)
    _new = group_users.build user: user
    _new.save
  end

  def add_user!(user)
    group_users.create! user: user
  end

  def remove_user(user)
    target = group_users.find_by user: user
    return false if target.nil?
    target.destroy
  end

  def remove_user!(user)
    target = group_users.find_by! user: user
    target.destroy!
  end

  def rest_users_size
    3 - group_users.size
  end

end
