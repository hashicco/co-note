require 'rails_helper'

RSpec.describe Group, type: :model do
  let!(:user01){ create(:user) }
  let!(:user02){ create(:user) }
  let!(:user03){ create(:user) }
  let!(:user04){ create(:user) }
  let!(:user05){ create(:user) }
  let!(:user06){ create(:user) }
  let!(:user07){ create(:user) }

  let!(:group01){ create(:group, :with_including_users, owner: user01, users: [user05, user06, user07] ) }
  let!(:group02){ create(:group, :with_including_users, owner: user01, users: [user06]) }
  let!(:group03){ create(:group, :with_including_users, owner: user01, users: [user07]) }
  let!(:group04){ create(:group, :with_including_users, owner: user02, users: [user05, user06]) }
  let!(:group05){ create(:group, :with_including_users, owner: user02, users: []) }
  let!(:group06){ create(:group, :with_including_users, owner: user03, users: [user05, user07]) }

  let!(:note01){ create(:note, :with_disclosed_groups, owner: user01, groups: [group01, group02]) }
  let!(:note02){ create(:note, :with_disclosed_groups, owner: user02, groups: [group04]) }
  let!(:note03){ create(:note, :with_disclosed_groups, owner: user03, groups: [group06]) }
  let!(:note04){ create(:note, :with_disclosed_groups, owner: user04, groups: []) }
  let!(:note05){ create(:note, :with_disclosed_groups, owner: user05, groups: []) }

  describe "#owner" do
    it "参照できる" do
      expect(group01.owner).to eq(user01)
      expect(group04.owner).to eq(user02)
      expect(group06.owner).to eq(user03)
    end
  end

  describe "#owned_by?" do
    it "所有者ならtrueを返す" do
      expect(group01.owned_by?(user01)).to eq(true)
      expect(group04.owned_by?(user02)).to eq(true)
      expect(group06.owned_by?(user03)).to eq(true)      
    end
    it "所有者でないならfalseを返す" do
      expect(group02.owned_by?(user05)).to eq(false)
      expect(group03.owned_by?(user06)).to eq(false)
      expect(group05.owned_by?(user07)).to eq(false)      
    end
  end

  describe "#including_users" do
    context "参照" do
      it "参照できる" do
        expect(group01.including_users).to contain_exactly(user05, user06, user07)
        expect(group02.including_users).to contain_exactly(user06)
        expect(group03.including_users).to contain_exactly(user07)
      end
    end
  end

  describe "scope including_user" do
    it do
      expect( Group::including_user( user05 ) ).to contain_exactly(group01, group04, group06)
      expect( Group::including_user( user06 ) ).to contain_exactly(group01, group02, group04)
    end
  end

end
