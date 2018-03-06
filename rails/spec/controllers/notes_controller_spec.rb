require 'rails_helper'

RSpec.describe NotesController, type: :controller do
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

  let(:valid_attributes) {
    {title: "hogehoge", text: "hogehogehogehogehoge"}
  }

  let(:invalid_attributes) {
    {title: "123"}
  }

  describe "GET #index" do
    it do
      get :index
      expect(response).to redirect_to(:login)
    end
    it do
      login_user(user01)
      get :index
      expect(response).to be_success
    end
  end

  describe "GET #show" do
    it do
      get :show, params: {id: note01.to_param}
      expect(response).to redirect_to(:login)
    end

    it do
      login_user(user01)
      get :show, params: {id: note01.to_param}
      expect(response).to be_success
    end

    it do
      login_user(user01)
      get :show, params: {id: note02.to_param}
      expect(response).to be_success
    end

    it do
      login_user(user01)
      get :show, params: {id: note03.to_param}
      expect(response).to redirect_to(:notes)
    end
  end

  describe "GET #new" do
    it do
      get :new
      expect(response).to redirect_to(:login)
    end
    it do
      login_user(user01)
      get :new
      expect(response).to be_success
    end
  end

  describe "GET #edit" do
    it do
      get :edit, params: {id: note01.to_param}
      expect(response).to redirect_to(:login)
    end
    it do
      login_user(user01)
      get :edit, params: {id: note01.to_param}
      expect(response).to be_success
    end
    it do
      login_user(user01)
      get :edit, params: {id: note02.to_param}
      expect(response).to redirect_to(:notes)
    end
  end

  describe "POST #create" do
    context "非ログイン" do
      it do
        post :create, params: {note: valid_attributes}
        expect(response).to redirect_to(:login)
      end
    end

    context "User01としてログイン" do
      it do
        login_user(user01)
        expect {
          post :create, params: {note: valid_attributes}
        }.to change(Note, :count).by(1)
      end
      it do
        login_user(user01)
        post :create, params: {note: valid_attributes}
        expect(response).to redirect_to( Note.last )
      end
    end
  end

  describe "PUT #update" do
    context "非ログイン" do
      it do
        put :update, params: {id: note01.to_param, note: valid_attributes}
        expect(response).to redirect_to(:login)
      end
    end

    context "User01としてログイン" do
      it do
        login_user(user01)
        put :update, params: {id: note01.to_param, note: valid_attributes}
        expect{ note01.reload }.to change{ note01.title }.from("hoge").to("hogehoge")
        expect(response).to redirect_to( note01 )
      end

      it
      #   login_user(user01)
      #   put :update, params: {id: note01.to_param, note: invalid_attributes}
      #   expect(response).to be_success
      # end

      it do
        login_user(user01)
        put :update, params: {id: note02.to_param, note: valid_attributes}
        expect(response).to redirect_to(:notes)
      end
    end
  end

  describe "DELETE #destroy" do
    context "非ログイン" do
      it do
        delete :destroy, params: {id: note01.to_param}
        expect(response).to redirect_to(:login)
      end
    end

    context "User01としてログイン" do
      it do
        login_user(user01)
        expect {
          delete :destroy, params: {id: note01.to_param}
        }.to change(Note, :count).by(-1)
        expect(response).to redirect_to(:notes)
      end

      it do
        login_user(user01)
        delete :destroy, params: {id: note02.to_param}
        expect(response).to redirect_to(:notes)
      end
    end
  end

end
