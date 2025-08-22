require "rails_helper"

RSpec.describe Category, type: :model do
    describe "validations" do
        it "valid category" do
            category = build(:category, user: create(:user))
            expect(category).to be_valid
        end

        it "default category type is set correctly when not provided" do
            category = create(:category, category_type: nil)
            expect(category.category_type).to eq("expense")
        end

        it "invalid category - missing required parameters" do
            category = build(:category, name: "", category_type: "invalid_type")
            expect(category).not_to be_valid
        end
    end

    describe "associations" do
        it "destroy category with children" do
            parent_category = create(:category)
            child_category = create(:category, parent: parent_category)
            parent_category.destroy
            expect(described_class).not_to exist(child_category.id)
        end

        it "on delete user delete categories" do
            user = create(:user)
            category = create(:category, user: user)
            user.destroy
            expect(described_class).not_to exist(category.id)
        end
    end
end
