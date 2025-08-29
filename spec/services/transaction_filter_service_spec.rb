# spec/services/transaction_filter_service_spec.rb
require 'rails_helper'

RSpec.describe TransactionFilterService do
  let(:user) { create(:user) }
  let(:currency) { create(:currency) }

  let(:category_income) { create(:category, category_type: 'income') }
  let(:category_expense) { create(:category, category_type: 'expense') }

  let!(:transaction_jan) { create(:transaction, user: user, currency: currency, category: category_income, amount: 100, transaction_date: '2025-01-10') }
  let!(:transaction_feb) { create(:transaction, user: user, currency: currency, category: category_expense, amount: 200, transaction_date: '2025-02-15') }
  let!(:transaction_march) { create(:transaction, user: user, currency: currency, category: category_income, amount: 300, transaction_date: '2025-03-20') }

  let(:base_scope) { user.transactions.includes(:category, :currency) }

  describe "#call" do
    context "when filtering by start_date" do
      let(:filters) { { start_date: '2025-02-01' } }

      it "returns transactions from start_date onwards" do
        result = described_class.new(base_scope, filters).call

        expect(result).to contain_exactly(transaction_feb, transaction_march)
      end
    end

    context "when filtering by end_date" do
      let(:filters) { { end_date: '2025-02-28' } }

      it "returns transactions upto end_date" do
        result = described_class.new(base_scope, filters).call

        expect(result).to contain_exactly(transaction_jan, transaction_feb)
      end
    end

    context "when filtering by date range" do
      let(:filters) { { start_date: '2025-01-15', end_date: '2025-03-01' } }

      it "returns transactions within the date range" do
        result = described_class.new(base_scope, filters).call

        expect(result).to contain_exactly(transaction_feb)
      end
    end

    context "when filtering by min_amount" do
      let(:filters) { { min_amount: '150' } }

      it "returns transactions with amount >= min_amount" do
        result = described_class.new(base_scope, filters).call

        expect(result).to contain_exactly(transaction_feb, transaction_march)
      end
    end

    context "when filtering by max_amount" do
      let(:filters) { { max_amount: '250' } }

      it "returns transactions with amount <= max_amount" do
        result = described_class.new(base_scope, filters).call

        expect(result).to contain_exactly(transaction_jan, transaction_feb)
      end
    end

    context "when filtering by amount range" do
      let(:filters) { { min_amount: '150', max_amount: '250' } }

      it "returns transactions within the amount range" do
        result = described_class.new(base_scope, filters).call

        expect(result).to contain_exactly(transaction_feb)
      end
    end

    context "when filtering by category_type" do
      let(:filters) { { category_type: 'expense' } }

      it "returns transactions with matching category_type" do
        result = described_class.new(base_scope, filters).call

        expect(result).to contain_exactly(transaction_feb)
      end
    end

    context "when multiple filters applied" do
      let(:filters) { { start_date: '2025-02-01', max_amount: '250', category_type: 'expense' } }

      it "returns transactions matching all filters" do
        result = described_class.new(base_scope, filters).call
        expect(result).to contain_exactly(transaction_feb)
      end
    end

    context "when no filters applied" do
      let(:filters) { {} }

      it "returns all transactions" do
        result = described_class.new(base_scope, filters).call

        expect(result).to contain_exactly(transaction_jan, transaction_feb, transaction_march)
      end
    end
  end
end
