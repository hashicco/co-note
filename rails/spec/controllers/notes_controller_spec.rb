require 'rails_helper'

require_relative '../init_data_context'
require_relative './contexts'

RSpec.describe NotesController, type: :controller, init_data: true do
  let(:valid_attributes) {
    {title: "hogehoge", text: "hogehogehogehogehoge"}
  }

  let(:group05){ create(:group, owner: user01) }
  let(:group06){ create(:group, owner: user01) }
  let(:valid_closures_attributes_for_user01){
    { "closures_attributes": {
        "0"=>{"group_id"=>group05.id}, 
        "1"=>{"group_id"=>group06.id}, 
        "2"=>{"group_id"=>""}
      }
    }
  }  

  describe "GET #index", login: false do
    it do
      get :index
      expect(response).to redirect_to(:login)
    end
  end

  describe "GET #index", login: :user01 do
    it do
      get :index
      expect(response).to be_success
    end
  end

  describe "GET #show", login: false do
    it do
      get :show, params: {id: note01.to_param}
      expect(response).to redirect_to(:login)
    end
  end

  describe "GET #show", login: :user01 do
    it do
      get :show, params: {id: note01.to_param}
      expect(response).to be_success
    end

    it do
      get :show, params: {id: note02.to_param}
      expect(response).to be_success
    end

    it do
      get :show, params: {id: note03.to_param}
      expect(response).to redirect_to(:notes)
    end
  end

  describe "GET #new", login: false do
    it do
      get :new
      expect(response).to redirect_to(:login)
    end
  end

  describe "GET #new", login: :user01 do
    it do
      get :new
      expect(response).to be_success
    end
  end

  describe "GET #edit", login: false do
    it do
      get :edit, params: {id: note01.to_param}
      expect(response).to redirect_to(:login)
    end
  end

  describe "GET #edit", login: :user01 do
    it do
      get :edit, params: {id: note01.to_param}
      expect(response).to be_success
    end
    it do
      get :edit, params: {id: note02.to_param}
      expect(response).to redirect_to(:notes)
    end
  end

  describe "POST #create", login: false do
    it do
      post :create, params: {note: valid_attributes}
      expect(response).to redirect_to(:login)
    end
  end

  describe "POST #create", login: :user01 do
    it do
      expect {
        post :create, params: {note: valid_attributes}
      }.to change(Note, :count).by(1)
    end
    it do
      post :create, params: {note: valid_attributes}
      expect(response).to redirect_to( Note.last )
    end
  end

  describe "PUT #update", login: false do
    it do
      put :update, params: {id: note01.to_param, note: valid_attributes}
      expect(response).to redirect_to(:login)
    end
  end

  describe "PUT #update", login: :user01 do
    it do
      put :update, params: {id: note01.to_param, note: valid_attributes}
      expect{ note01.reload }.to change{ note01.title }.from("hoge").to("hogehoge")
      expect(response).to redirect_to( note01 )
    end

    it do
      put :update, params: {id: note02.to_param, note: valid_attributes}
      expect(response).to redirect_to(:notes)
    end
  end

  describe "DELETE #destroy", login: false do
    it do
      delete :destroy, params: {id: note01.to_param}
      expect(response).to redirect_to(:login)
    end
  end

  describe "DELETE #destroy", login: :user01 do
    it do
      expect {
        delete :destroy, params: {id: note01.to_param}
      }.to change(Note, :count).by(-1)
      expect(response).to redirect_to(:notes)
    end

    it do
      delete :destroy, params: {id: note02.to_param}
      expect(response).to redirect_to(:notes)
    end
  end

end
