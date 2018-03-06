require 'rails_helper'

require_relative '../init_data_context'
require_relative './contexts'

RSpec.describe UsersController, type: :controller, init_data: true do
  let(:valid_attributes) {
    { "name": "hogehoge",
      "email": "hogehoge@sample.com", 
      "password": "password",
      "password_confirmation": "password",
    }
  }

  describe "GET #new", login: false do
    it do
      get :new
      expect(response).to be_success
    end
  end

  describe "GET #new", login: :user01 do
    it do
      get :new
      expect(response).to redirect_to(:root)
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
      get :edit, params: {id: user01.to_param}
      expect(response).to be_success
    end
    it do
      get :edit, params: {id: user02.to_param}
      expect(response).to redirect_to(:root)
    end
  end

  describe "POST #create", login: false do
    it do
      post :create, params: {user: valid_attributes}
      expect(response).to redirect_to(:login)
    end
  end

  describe "POST #create", login: :user01 do
    it do
      expect {
        post :create, params: {user: valid_attributes}
      }.to change(User, :count).by(1)
    end
    it do
      post :create, params: {user: valid_attributes}
      expect(response).to redirect_to( :login )
    end
  end

  describe "PUT #update", login: false do
    it do
      put :update, params: {id: user01.to_param, user: valid_attributes}
      expect(response).to redirect_to(:login)
    end
  end

  describe "PUT #update", login: :user01 do
    it do
      put :update, params: {id: user01.to_param, user: valid_attributes}
      expect(response).to redirect_to( :root )
    end

    it do
      put :update, params: {id: user02.to_param, user: valid_attributes}
      expect(response).to redirect_to( :root )
    end
  end

end
