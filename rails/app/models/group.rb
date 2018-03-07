class Group < ApplicationRecord
  include FriendlyId
  friendly_id :code
  before_create ->{ self.code = SecureRandom.hex(10)  }

  belongs_to :owner, foreign_key: :owner_user_id, class_name: "User"
  has_many :group_users, dependent: :destroy
  has_many :including_users, through: :group_users, source: :user
  accepts_nested_attributes_for :group_users, reject_if: ->(attrs){ attrs['user_id'].blank? }, allow_destroy: true

  has_many :disclosures, class_name: "NoteDisclosure", dependent: :destroy
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

  def rest_users_size
    3 - group_users.size
  end

end
