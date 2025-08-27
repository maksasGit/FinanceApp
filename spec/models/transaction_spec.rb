require "rails_helper"

RSpec.describe Transaction, type: :model do
    describe "validations" do
        it "valid transaction" do
            transaction = build(:transaction)
            expect(transaction).to be_valid
        end

        it "invalid transaction - missing required parameters" do
            transaction = build(:transaction, amount: nil, user: nil)
            expect(transaction).not_to be_valid
        end

        it "invalid transaction - negative amount" do
            transaction = build(:transaction, amount: -50)
            expect(transaction).not_to be_valid
        end

        it "invalid transaction - description too long" do
            transaction = build(:transaction, description: "a" * 300)
            expect(transaction).not_to be_valid
        end

        it "transaction date is set to current date if not provided" do
            transaction = create(:transaction, transaction_date: nil)
            expect(transaction.transaction_date).not_to be_nil
        end
    end

    describe "associations" do
        it "transaction deletion cascades to user" do
            transaction = create(:transaction)
            user = transaction.user
            user.destroy
            expect(described_class).not_to exist(transaction.id)
        end
    end

    describe "#amount_adjustment" do
        let(:income_category) { create(:category, category_type: "income") }
        let(:expense_category) { create(:category, category_type: "expense") }

        it "returns positive amount for income category" do
            transaction = build(:transaction, amount: 100, category: income_category)

            expect(transaction.amount_adjustment).to eq(100)
        end

        it "returns negative amount for expense category" do
            transaction = build(:transaction, amount: 100, category: expense_category)

            expect(transaction.amount_adjustment).to eq(-100)
        end
    end
end
