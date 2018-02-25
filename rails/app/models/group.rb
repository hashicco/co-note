class Group < ApplicationRecord
  belongs_to :owner, foreign_key: :owner_user_id, class_name: "User"
  has_many :group_users
  has_many :including_users, through: :group_users, source: :user

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

end
