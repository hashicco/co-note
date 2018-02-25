class GroupUser < ApplicationRecord
  belongs_to :group, dependent: :destroy
  belongs_to :user, dependent: :destroy

  validates :user_id, :uniqueness => {:scope => :group_id}
  validate ->{ errors.add(:user_id, I18n.t('errors.messages.cannot_add_owner') ) if group.owner == user }
end
