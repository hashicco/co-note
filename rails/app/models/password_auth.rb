class PasswordAuth
  include Virtus.model
  include ActiveModel::Model
  
  attribute :email,    String
  attribute :password,  String
end