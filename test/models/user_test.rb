require "test_helper"

class UserTest < ActiveSupport::TestCase
  test "valid user" do
    user = User.new(name: "John Doe", email: "example@email.com", password: "somepassword")
    assert user.valid?
  end

  test "invalid user - missing required parameters" do
    user = User.new(name: "", password: "1")
    assert_not user.valid?
  end

  test "invalid user - repeated email" do
    user1 = User.create(name: "John Doe", email: "example@email.com", password: "somepassword")
    user2 = User.new(name: "John Smith", email: "example@email.com", password: "somepassword")
    assert_not user2.valid?
  end
end
