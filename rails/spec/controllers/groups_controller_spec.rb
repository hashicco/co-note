require 'rails_helper'

require_relative '../init_data_context'
require_relative './contexts'

RSpec.describe GroupsController, type: :controller, init_data: true do
  let(:user04){ create(:user) }
  let(:user05){ create(:user) }
  let(:valid_attributes) {
    { "name": "hogehoge", 
      "group_users_attributes": {
        "0"=>{"user_id"=>user04.id}, 
        "1"=>{"user_id"=>user05.id}, 
        "2"=>{"user_id"=>""}
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
      get :show, params: {id: group01.to_param}
      expect(response).to redirect_to(:login)
    end
  end

  describe "GET #show", login: :user01 do
    it do
      get :show, params: {id: group01.to_param}
      expect(response).to be_success
    end

    it do
      get :show, params: {id: group03.to_param}
      expect(response).to redirect_to(:groups)
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
      get :edit, params: {id: group01.to_param}
      expect(response).to redirect_to(:login)
    end
  end

  describe "GET #edit", login: :user01 do
    it do
      get :edit, params: {id: group01.to_param}
      expect(response).to be_success
    end
    it do
      get :edit, params: {id: group03.to_param}
      expect(response).to redirect_to(:groups)
    end
  end

  describe "POST #create", login: false do
    it do
      post :create, params: {group: valid_attributes}
      expect(response).to redirect_to(:login)
    end
  end

  describe "POST #create", login: :user01 do
    it do
      expect {
        post :create, params: {group: valid_attributes}
      }.to change(Group, :count).by(1)
    end
    it do
      post :create, params: {group: valid_attributes}
      expect(response).to redirect_to( Group.last )
    end
  end

  describe "PUT #update", login: false do
    it do
      put :update, params: {id: group01.to_param, group: valid_attributes}
      expect(response).to redirect_to(:login)
    end
  end

  describe "PUT #update", login: :user01 do
    it do
      put :update, params: {id: group01.to_param, group: valid_attributes}
      expect{ group01.reload }.to change{ group01.name }.from("GroupHogeHoge").to("hogehoge")
      expect(response).to redirect_to( group01 )
    end

    it do
      put :update, params: {id: group03.to_param, group: valid_attributes}
      expect(response).to redirect_to(:groups)
    end
  end

  describe "DELETE #destroy", login: false do
    it do
      delete :destroy, params: {id: group01.to_param}
      expect(response).to redirect_to(:login)
    end
  end

  describe "DELETE #destroy", login: :user01 do
    it do
      expect {
        delete :destroy, params: {id: group01.to_param}
      }.to change(Group, :count).by(-1)
      expect(response).to redirect_to(:groups)
    end

    it do
      delete :destroy, params: {id: group03.to_param}
      expect(response).to redirect_to(:groups)
    end
  end

end
