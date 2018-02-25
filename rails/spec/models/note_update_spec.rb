require 'rails_helper'

RSpec.describe NoteUpdate, type: :model do
  describe "self.create" do
    it "statusの初期値は、waiting"
  end

  describe "#note" do
    it "更新対象のノートが参照できる"
  end

  describe "updater" do
    it "更新Userを参照できる"
  end

  describe "#validate_unique" do
    it "既に他に未承認のUpdateが合ったら、Validationに失敗する"
  end

  describe "#validate_updater" do
    it "更新Userに更新権限がなければ、Validationに失敗する"
  end

  describe "#on_approbved" do
    it "承認されるとnoteが書き換えられ、statusがapprovedに変わる。"
  end

  describe "#on_rejected" do
    it "否認されると、noteは書き換えられず、statusがrejectedに変わる。"

  end

  describe "#update_note" do
    it "noteを自身の内容で書き換える"
  end
end
