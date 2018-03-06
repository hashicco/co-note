
RSpec.shared_context '非ログイン' do
end

RSpec.shared_context 'User01としてログイン' do
  before do
    login_user(user01)
  end
end

RSpec.shared_context 'User02としてログイン' do
  before do
    login_user(user02)
  end
end

RSpec.configure do |rspec|
  rspec.include_context '非ログイン', :login => false
  rspec.include_context 'User01としてログイン', :login => :user01
  rspec.include_context 'User02としてログイン', :login => :user02
end