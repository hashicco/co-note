require 'rails_helper'

RSpec.describe Note, type: :model do
  describe "#unapproved_update" do
    it "未承認のUpdateが参照できる"
  end

  describe "#update_histories" do
    it "更新履歴を参照できる"
  end

  describe "#destroy" do
    it "付随するUpdateも削除される"
  end

  describe "#readable?" do
    it "与えられたUserが自身を参照できるかを返す"
  end

  describe "#disclosed_groups" do
    it "公開されているGroupを参照する"
  end

end
