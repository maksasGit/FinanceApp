require 'rails_helper'

RSpec.describe TransactionUpdateService, type: :service do
  subject(:service) { described_class.new(transaction, update_params) }

  let(:user) { create(:user, balance: 100.0) }
  let(:category_expense) { create(:category, category_type: 'expense') }
  let(:category_income) { create(:category, category_type: 'income') }
  let(:currency) { create(:currency) }

  let!(:transaction) do
    create(:transaction, user: user, category: category_expense, amount: 50.0, currency: currency)
  end

  describe '#call' do
    context 'with valid amount update' do
      let(:update_params) { { amount: 30.0 } }

      it 'updates the transaction amount' do
        expect(service.call.reload.amount).to eq(30.0)
      end

      it 'updates the user balance correctly (adjusted by difference)' do
        # Not modified Transaction change user balance on -50, we change it on -30 so user balance should increase on 20
        expect { service.call }.to change { user.reload.balance }.by(20.0)
      end
    end

    context 'with valid category change (expense to income)' do
      let(:update_params) { { category_id: category_income.id } }

      it 'updates the category' do
        expect(service.call.reload.category).to eq(category_income)
      end

      it 'updates the user balance correctly' do
        # Not modified Transaction change user balance on -50, we change it on +50 so user balance should increase on 100
        expect { service.call }.to change { user.reload.balance }.by(100.0)
      end
    end

    context 'with valid amount and category change' do
      let(:update_params) { { amount: 20.0, category_id: category_income.id } }

      it 'updates amount' do
        service.call

        expect(transaction.reload.amount).to eq(20.0)
      end

      it 'updates category' do
        service.call

        expect(service.call.category).to eq(category_income)
      end

      it 'correctly adjusts user balance' do
        # Not modified Transaction change user balance on -50, we change it on +20 so user balance should increase on 70
        expect { service.call }.to change { user.reload.balance }.by(70.0)
      end
    end

    context 'with invalid amount' do
      let(:update_params) { { amount: -10.0 } }

      it 'raises validation error and does not change balance' do
        begin
          service.call
        rescue ActiveRecord::RecordInvalid
        end

        expect(user.reload.balance).to eq(100.0)
      end
    end

    context 'with invalid category' do
      let(:update_params) { { category_id: 0 } }

      it 'raises RecordInvalid error' do
        expect { service.call }.to raise_error(ActiveRecord::RecordInvalid)
      end
    end
  end
end
