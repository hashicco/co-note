RSpec.shared_context "初期データ" do
  let!(:user01){ create(:user) }
  let!(:user02){ create(:user) }
  let!(:user03){ create(:user) }

  let!(:group01){ create(:group, :with_including_users, owner: user01, users: [user02, user03] ) }
  let!(:group02){ create(:group, :with_including_users, owner: user01, users: [user02]) }
  let!(:group03){ create(:group, :with_including_users, owner: user02, users: [user01]) }
  let!(:group04){ create(:group, :with_including_users, owner: user02, users: [user03]) }

  let!(:note01){ create(:note, :with_disclosed_groups, owner: user01, groups: [group01]) }
  let!(:note02){ create(:note, :with_disclosed_groups, owner: user02, groups: [group03, group04]) }
  let!(:note03){ create(:note, :with_disclosed_groups, owner: user03, groups: []) }
end

RSpec.configure do |rspec|
  rspec.include_context '初期データ', :init_data => true
end
