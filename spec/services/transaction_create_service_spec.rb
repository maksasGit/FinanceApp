require 'rails_helper'

RSpec.describe TransactionCreateService, type: :service do
  let(:user) { create(:user, balance: 100.0) }
  let(:category_income) { create(:category, category_type: 'income') }
  let(:category_expense) { create(:category, category_type: 'expense') }
  let(:currency) { create(:currency) }

  describe '#call' do
    context 'when creating an income transaction' do
      let(:params) { { amount: 50.0, category_id: category_income.id, currency_id: currency.id } }

      it 'creates transaction and adds to user balance' do
        service = described_class.new(user, category_income, params)
        service.call

        expect(user.reload.balance).to eq(150.0)
      end
    end

    context 'when creating an expense transaction' do
      let(:params) { { amount: 50.0, category_id: category_expense.id, currency_id: currency.id } }

      it 'creates transaction and removes from user balance' do
        service = described_class.new(user, category_expense, params)
        service.call

        expect(user.reload.balance).to eq(50.0)
      end
    end
  end
end
