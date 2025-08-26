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
        it "is valid when parent category exists" do
            parent_category = create(:category)
            child_category = build(:category, parent: parent_category)

            expect(child_category).to be_valid
        end

        it "is invalid when parent_id does not exist" do
            child_category = build(:category, parent_id: 100000)
            child_category.valid?

            expect(child_category.errors[:parent_id]).to include("must refer to an existing category")
        end

        it "is valid when user exists" do
            user = create(:user)
            category = create(:category, user_id: user.id)

            expect(category).to be_valid
        end

        it "is invalid when user does not exist" do
            category = build(:category, user_id: 100000)
            category.valid?

            expect(category.errors[:user_id]).to include("must refer to an existing user")
        end

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
