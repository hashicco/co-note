require 'rails_helper'

RSpec.describe User, type: :model do
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

  describe "#groups" do
    context "参照" do
      it "数が合う" do
        expect( user01.groups.count ).to eq(3)
        expect( user02.groups.count ).to eq(2)
        expect( user04.groups.count ).to eq(0)
      end

      it "nameが一致する" do
        expect( user01.groups ).to match_array([group01, group02, group03])
        expect( user02.groups ).to match_array([group04, group05])
      end
    end

    context "追加" do
      it "追加できる" do
        expect{ 
          user01.groups.build name: "newGroup07 of User01"
          user01.save! 
        }.to change{ user01.groups.count }.by(1)
      end
    end

    context "削除" do
      it "削除できる" do
        expect{
          user01.groups.first.destroy
        }.to change{ user01.groups.count }.by(-1)
      end

      it "紐づくGroupUserも同時に削除される"
    end
  end

  describe "#add_user_to" do
    it "Groupにユーザを追加できる" do
      expect{
        user01.add_user_to!(group01, user02)
      }.to change{ group01.including_users.count }.by(1)
      expect( group01.including_users ).to include(user02)
    end
  end

  describe "#remove_user_from" do
    it "Groupからユーザを削除できる" do
      expect{
        user01.remove_user_from!(group01, user06)
      }.to change{ group01.including_users.count }.by(-1)
      expect( group01.including_users ).to contain_exactly(user05, user07)
    end

  end

  describe "#included_groups" do
    it "参照できる" do
      expect( user05.included_groups ).to contain_exactly(group01, group04, group06)
      expect( user06.included_groups ).to contain_exactly(group01, group02, group04)
    end
  end

  describe "#notes" do
    context "参照" do

    end

    context "追加" do

    end

    context "削除" do

    end
  end

  describe "#readable_notes" do
    it "参照できるNote群を参照できる"
  end

  describe "#receved_waiting_update" do
    it "自身に承認依頼されているUpdateを参照できる"

  end

  describe "#waiting_updates" do
    it "自身が承認依頼しているUpdateを参照できる"

  end

  describe "#approve" do
    it "Updateを承認できる"

    it "権限がない場合は承認できない"

  end

  describe "#reject" do
    it "Updateを否認できる"

    it "権限がない場合は否認できない"

  end

  describe "#build_update_of" do
    it "対象のNoteのUpdateをbuildして返す"

    it "保存はされない"

  end

  describe "#disclose_note_to" do
    it "GroupにNoteを公開できる"

  end

  describe "#close_note_from" do
    it "GroupからNoteを非公開にできる"

  end



end
