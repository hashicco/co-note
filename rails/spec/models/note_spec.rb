require 'rails_helper'

RSpec.describe Note, type: :model do
  let!(:user01){ create(:user) }
  let!(:user02){ create(:user) }
  let!(:user03){ create(:user) }
  let!(:user04){ create(:user) }
  let!(:user05){ create(:user) }
  let!(:user06){ create(:user) }
  let!(:user07){ create(:user) }

  let!(:group01){ create(:group, :with_including_users, owner: user01, users: [user05, user06] ) }
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

  describe "disclosed_to?" do
    it do
      expect( note01.disclosed_to?(group01) ).to eq(true)
      expect( note01.disclosed_to?(user05) ).to eq(true)
      expect( note01.disclosed_to?(group03) ).to eq(false)
      expect( note01.disclosed_to?(user02) ).to eq(false)
      expect( note05.disclosed_to?(group01) ).to eq(true)
      expect( note05.disclosed_to?(user01) ).to eq(true)    
    end
  end
 
  describe "#disclosed_to_user?" do
    it do
      expect( note01.disclosed_to_user?(user05) ).to eq(true)
      expect( note01.disclosed_to_user?(user02) ).to eq(false)
    end
  end

  describe "#disclosed_to_group?" do
    it do
      expect( note01.disclosed_to_group?(group01) ).to eq(true)
      expect( note01.disclosed_to_group?(group03) ).to eq(false)
    end
  end
    
  describe "#disclosed_to_public?" do
    it "参照" do
      expect( note01.disclosed_to_public? ).to eq(false)
      expect( note05.disclosed_to_public? ).to eq(true)
    end
  end

  describe "#disclose_to_public!" do
    it "変更できる"  do
      expect{ note01.disclose_to_public! }.to change{ note01.disclosed_to_public? }.from(false).to(true)
    end

    it "変更できない" do
      expect{ note05.disclose_to_public! }.to raise_error(RuntimeError)
    end
  end

  describe "#disclosed_groups" do
    it do
      expect( note01.disclosed_groups ).to contain_exactly(group01, group02)
      expect( note02.disclosed_groups ).to contain_exactly(group04)

    end
  end


  describe "#close_from_public!" do
    it "変更できる"  do
      expect{ note05.close_from_public! }.to change{ note05.disclosed_to_public? }.from(true).to(false)
    end

    it "変更できない" do
      expect{ note01.close_from_public! }.to raise_error(RuntimeError)
    end
  end

  describe "#disclose_to" do
    context "正常系" do
      it do
        expect{ note01.disclose_to!(group03) }.to change{ 
          note01.disclosed_to?(group03) 
        }.from(false).to(true).and( change{
          note01.disclosed_to?(user07)
        }.from(false).to(true) )
        expect( note01.disclosed_to?(group03) ).to eq(true)
        expect( note01.disclosed_to?(user07) ).to eq(true)
      end
    end

    context "異常系" do
      it "ownerのGroup以外にはdiscloseできない" do
        expect{ note01.disclose_to!(group04) }.to raise_error(RuntimeError)
      end

      it "既にdisclose済みのGroupにはdiscloseできない" do
        expect{ note01.disclose_to!(group01) }.to raise_error(RuntimeError)
      end
    end
  end

  describe "#enclose_from" do
    context "正常系" do
      it 
    end

    context "異常系" do
      it
    end
  end

end
