require 'rails_helper'

require_relative '../init_data_context'
require_relative './contexts'

RSpec.describe PasswordAuthsController, type: :controller, init_data: true do
  let(:valid_attributes) {
    { "email": "hogehoge@example.com", 
      "password": "password"}
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

  describe "GET #create", login: false do
    let(:user04){ create :user, name: "hogehoge", 
                                email: "hogehoge@example.com", 
                                password: "password", 
                                password_confirmation: "password" }
    it do
      get :create, params: {password_auth: valid_attributes}
      expect(response).to be_success
    end
  end

  describe "GET #destroy" do
    it do
      get :destroy
      expect(response).to redirect_to(:login)
    end
  end

end
