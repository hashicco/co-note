class Note < ApplicationRecord
  belongs_to :owner, foreign_key: :owner_user_id, class_name: "User"
  has_many :disclosures, class_name: "NoteDisclosure"
  has_many :disclosed_groups, through: :disclosures, source: :group

  scope :disclosed_to_or_owned_by, ->(user){
    eager_load(:disclosed_groups => :group_users).where( 
      arel_table[:disclosed_to_public].eq(true).or(
        arel_table[:owner_user_id].eq( user.id ).or(
          GroupUser.arel_table[:user_id].eq( user.id)
        )
      )
    ).distinct
  }

  def owned_by?(user)
    owner == user
  end

  def disclose_to_public!
    raise if disclosed_to_public?
    update! disclosed_to_public: true   
  end

  def close_from_public!
    raise unless disclosed_to_public?
    update! disclosed_to_public: false   
  end

  def disclosure_of(group)
    disclosures.find_by(group: group)
  end

  def disclose_to!(group)
    raise unless group.owned_by? owner
    existed_disclosure = disclosure_of(group)
    raise if existed_disclosure
    disclosures.create!(group: group)
  end

  def disclose_to(group)
    disclose_to!(group)
    true
  rescue => e
    return false
  end

  def enclose_from!(group)
    existed_disclosure = disclosure_of(group)
    raise unless existed_disclosure
    existed_disclosure.destroy!
  end

  def enclose_from(group)
    enclose_from!(group)
    true
  rescue => e
    return false
  end

  def disclosed_to?(user_or_group)
    return true if disclosed_to_public?

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

end
