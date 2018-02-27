require 'rails_helper'

RSpec.describe User, type: :model do
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
  let!(:note05){ create(:note, :with_disclosed_groups, owner: user05, groups: [], disclosed_to_public: true) }
  let!(:note06){ create(:note, :with_disclosed_groups, owner: user01, groups: [group01, group02]) }
  let!(:note07){ create(:note, :with_disclosed_groups, owner: user01, groups: [group01, group02]) }

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
      it do
        expect{ 
          user01.groups.build name: "newGroup07 of User01"
          user01.save! 
        }.to change{ user01.groups.count }.by(1)
      end
    end

    context "削除" do
      it  do
        expect{
          user01.groups.first.destroy
        }.to change{ user01.groups.count }.by(-1)
      end

      it "紐づくGroupUserも同時に削除される"
    end
  end

  describe "#add_user_to" do
    it do
      expect{
        user01.add_user_to!(group01, user02)
      }.to change{ group01.including_users.count }.by(1)
      expect( group01.including_users ).to include(user02)
    end
  end

  describe "#remove_user_from" do
    it do
      expect{
        user01.remove_user_from!(group01, user06)
      }.to change{ group01.including_users.count }.by(-1)
      expect( group01.including_users ).to contain_exactly(user05, user07)
    end

  end

  describe "#included_groups" do
    it do
      expect( user05.included_groups ).to contain_exactly(group01, group04, group06)
      expect( user06.included_groups ).to contain_exactly(group01, group02, group04)
    end
  end

  describe "#notes" do
    context "参照" do
      it do
        expect( user01.notes.count ).to eq(3)
        expect( user01.notes ).to contain_exactly(note01, note06, note07)
      end
    end

    context "追加" do
      it do
        expect{ 
          user01.notes.build title: "newNote08 of User01", text: "hogehoge"
          user01.save! 
        }.to change{ user01.notes.count }.by(1)
        expect( user01.notes.count ).to eq(4)
      end
    end

    context "削除" do
      it do
        expect{
          user01.notes.last.destroy
        }.to change{ user01.notes.count }.by(-1)
      end
    end
  end

  describe "#disclosed_or_own_notes" do
    it "参照できるNote群を参照できる" do
      expect( user01.disclosed_or_own_notes ).to contain_exactly(note01, note05, note06, note07)
      expect( user06.disclosed_or_own_notes ).to contain_exactly(note01, note02, note05, note06, note07)
    end
  end

  describe "#disclose_note_to!" do
    it "GroupにNoteを公開できる" do
      expect{
        user01.disclose_note_to!(group03, note01)
      }.to change{ note01.disclosed_to?(group03) }.from(false).to(true)
    end
  end

  describe "#enclose_note_from!" do
    it "GroupからNoteを非公開にできる" do
      expect{
        user01.enclose_note_from!(group01, note01)
      }.to change{ note01.disclosed_to?(group01) }.from(true).to(false)
    end
  end

end
