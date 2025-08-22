require "test_helper"

class CategoryTest < ActiveSupport::TestCase
    test "valid category" do
      user = User.create(name: "John Doe", email: "example@email.com", password: "somepassword")
      category = Category.new(name: "Groceries", category_type: "expense", user: user)
      assert category.valid?
    end

    test "default category type is set correctly when not provided" do
      category = Category.new(name: "Miscellaneous")
      category.save
      assert_equal "expense", category.category_type
    end

    test "invalid category - missing required parameters" do
      category = Category.new(name: "", category_type: "invalid_type")
      assert_not category.valid?
    end


    test "destroy category with children" do
      parent_category = Category.create(name: "Parent", category_type: "expense")
      child_category = Category.create(name: "Child", category_type: "expense", parent: parent_category)
      parent_category.destroy
      assert_not Category.exists?(child_category.id)
    end

    test "on delete user delete categories" do
      user = User.create(name: "John Doe", email: "example@email.com", password: "somepassword")
      category = Category.create(name: "Utilities", category_type: "expense", user: user)
      user.destroy
      assert_not Category.exists?(category.id)
    end
end
