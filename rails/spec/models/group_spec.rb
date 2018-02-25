require 'rails_helper'

RSpec.describe Group, type: :model do
  let!(:user01){ create(:user, name: "User01", email: "user01@example.com") }
  let!(:user02){ create(:user, name: "User02", email: "user02@example.com") }
  let!(:user03){ create(:user, name: "User03", email: "user03@example.com") }
  let!(:user04){ create(:user, name: "User04", email: "user04@example.com") }
  let!(:user05){ create(:user, name: "User05", email: "user05@example.com") }
  let!(:user06){ create(:user, name: "User06", email: "user06@example.com") }
  let!(:user07){ create(:user, name: "User07", email: "user07@example.com") }

  let!(:group01){ create(:group, :with_including_users, name: "Group01 of User01", owner: user01, users: [user05, user06, user07] ) }
  let!(:group02){ create(:group, :with_including_users, name: "Group02 of User01", owner: user01, users: [user06]) }
  let!(:group03){ create(:group, :with_including_users, name: "Group03 of User01", owner: user01, users: [user07]) }
  let!(:group04){ create(:group, :with_including_users, name: "Group04 of User02", owner: user02, users: [user05, user06]) }
  let!(:group05){ create(:group, :with_including_users, name: "Group05 of User02", owner: user02, users: []) }
  let!(:group06){ create(:group, :with_including_users, name: "Group06 of User03", owner: user03, users: [user05, user07]) }

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

  describe "#add_user" do
    context "正常系" do
      it "追加できる" do
        expect{ 
          group01.add_user! user02
        }.to change{ group01.including_users.count }.by(1)
      end
    end

    context "異常系" do
      it "既にいるユーザは追加できない" do
        expect{
          group01.add_user! user05
        }.to raise_error( ActiveRecord::RecordInvalid )
        expect(
          group01.add_user user05
        ).to eq(false)
      end

      it "ownerは追加できない" do
        expect{
          group01.add_user! user01
        }.to raise_error( ActiveRecord::RecordInvalid )
        expect(
          group01.add_user user01
        ).to eq(false)
      end
    end
  end

  describe "#remove_user" do
    context "正常系" do
      it "削除できる" do
        expect{
          group01.remove_user! user05
        }.to change{ group01.including_users.count }.by(-1)
        expect{
          group01.remove_user user06
        }.to change{ group01.including_users.count }.by(-1)
      end
    end

    context "異常系" do
      it "含まれていないユーザは削除できない" do
        expect{
          group02.remove_user! user07
        }.to raise_error(ActiveRecord::RecordNotFound)
        expect(
          group02.remove_user user07
        ).to eq(false)
      end
    end
  end
end
