require 'rails_helper'

RSpec.describe TransactionDeleteService, type: :service do
  let(:user) { create(:user, balance: 100.0) }
  let(:category_expense) { create(:category, category_type: 'expense') }
  let(:category_income) { create(:category, category_type: 'income') }
  let(:currency) { create(:currency) }

  context 'with an expense transaction' do
    subject(:service) { described_class.new(transaction) }

    let!(:transaction) { create(:transaction, user: user, category: category_expense, amount: 50.0, currency: currency) }

    it 'deletes the transaction' do
      expect { service.call }.to change(Transaction, :count).by(-1)
    end

    it 'increases the user balance by the transaction amount adjustment' do
      expect { service.call }.to change { user.reload.balance }.by(50.0)
    end
  end

  context 'with an income transaction' do
    subject(:service) { described_class.new(transaction) }

    let!(:transaction) { create(:transaction, user: user, category: category_income, amount: 50.0, currency: currency) }

    it 'deletes the transaction' do
      expect { service.call }.to change(Transaction, :count).by(-1)
    end

    it 'decreases the user balance by the transaction amount adjustment' do
      expect { service.call }.to change { user.reload.balance }.by(-50.0)
    end
  end
end
