require 'rails_helper'

RSpec.describe User, type: :model do
  describe "self.create" do
    it ""

  end



  describe "#groups" do
    it "参照できる"

    it "更新できる"

    it "追加できる"

    it "削除できる"

  end

  describe "#add_user_to" do
    it "Groupにユーザを追加できる"

  end

  describe "#remove_user_from" do
    it "Groupからユーザを削除できる"

  end

  describe "#notes" do
    it "参照できる"

    it "更新できる"

    it "追加できる"

    it "削除できる"

  end

  describe "#readable_notes" do
    it "参照できるNote群を参照できる"
  end

  describe "#receved_waiting_update" do
    it "自身に承認依頼されているUpdateを参照できる"

  end

  describe "#waiting_updates" do
    it "自身が承認依頼しているUpdateを参照できる"

  end

  describe "#approve" do
    it "Updateを承認できる"

    it "権限がない場合は承認できない"

  end

  describe "#reject" do
    it "Updateを否認できる"

    it "権限がない場合は否認できない"

  end

  describe "#build_update_of" do
    it "対象のNoteのUpdateをbuildして返す"

    it "保存はされない"

  end

  describe "#disclose_note_to" do
    it "GroupにNoteを公開できる"

  end

  describe "#close_note_from" do
    it "GroupからNoteを非公開にできる"

  end



end
