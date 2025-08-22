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
            expect(Transaction.exists?(transaction.id)).to be_falsey
        end
    end
end
