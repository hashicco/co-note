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
    {}
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
      it
    end

    context "User01としてログイン" do
      it do
        login_user(user01)
        put :update, params: {id: note01.to_param, note: valid_attributes}
        expect{ note01.reload }.to change{ note01.title }.from("hoge").to("hogehoge")
      end

      it
    end
  end

  #   context "with invalid params" do
  #     it "returns a success response (i.e. to display the 'edit' template)" do
  #       note = Note.create! valid_attributes
  #       put :update, params: {id: note.to_param, note: invalid_attributes}, session: valid_session
  #       expect(response).to be_success
  #     end
  #   end
  # end

  # describe "DELETE #destroy" do
  #   it "destroys the requested note" do
  #     note = Note.create! valid_attributes
  #     expect {
  #       delete :destroy, params: {id: note.to_param}, session: valid_session
  #     }.to change(Note, :count).by(-1)
  #   end

  #   it "redirects to the notes list" do
  #     note = Note.create! valid_attributes
  #     delete :destroy, params: {id: note.to_param}, session: valid_session
  #     expect(response).to redirect_to(notes_url)
  #   end
  # end

end
