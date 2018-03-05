class User < ApplicationRecord
  authenticates_with_sorcery!

  has_many :authentications, :dependent => :destroy
  accepts_nested_attributes_for :authentications

  has_many :groups, foreign_key: :owner_user_id
  has_many :group_users
  has_many :included_groups, through: :group_users, source: :group

  has_many :notes, foreign_key: :owner_user_id

  validates :email, uniqueness: true, presence: true
  validates :name, presence: true
  validates :password, length: { minimum: 3 }, if: -> { new_record? || changes[:crypted_password] }
  validates :password, confirmation: true, if: -> { new_record? || changes[:crypted_password] }
  validates :password_confirmation, presence: true, if: -> { new_record? || changes[:crypted_password] }

  scope :without, ->(user){
    where.not(id: user.id)
  }
end
