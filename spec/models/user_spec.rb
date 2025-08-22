require "rails_helper"

RSpec.describe User, type: :model do
  describe "validations" do
    it "valid user" do
      user = build(:user)
      expect(user).to be_valid
    end

    it "invalid user - missing required parameters" do
      user = build(:user, name: "", password: "1")
      expect(user).not_to be_valid
    end

    it "invalid user - repeated email" do
      create(:user, email: "example@email.com")
      user2 = build(:user, email: "example@email.com")
      expect(user2).not_to be_valid
    end
  end
end
