class Note < ApplicationRecord
  include FriendlyId
  friendly_id :code
  before_create ->{ self.code = SecureRandom.hex(10)  }

  belongs_to :owner, foreign_key: :owner_user_id, class_name: "User"
  has_many :disclosures, class_name: "NoteDisclosure", dependent: :destroy
  has_many :disclosed_groups, through: :disclosures, source: :group
  accepts_nested_attributes_for :disclosures, reject_if: ->(attrs){ attrs['group_id'].blank? }, allow_destroy: true

  scope :disclosed_to_or_owned_by, ->(user){
    eager_load(:disclosed_groups => {:group_users => :user}).where( 
      arel_table[:owner_user_id].eq( user.id ).or(
        GroupUser.arel_table[:user_id].eq( user.id)
      )
    ).distinct
  }

  def owned_by?(user)
    owner == user
  end

  def disclosure_of(group)
    disclosures.find_by(group: group)
  end

  def disclosed_to?(user_or_group)
    case user_or_group
    when User
      disclosed_to_user?(user_or_group)
    when Group
      disclosed_to_group?(user_or_group)
    else
      raise
    end
  end

  def disclosed_to_user?(user)
    disclosed_groups.including_user(user).any?
  end

  def disclosed_to_group?(group)
    disclosure_of(group).present?
  end

  def rest_disclosures_size
    3 - disclosures.size
  end

end
