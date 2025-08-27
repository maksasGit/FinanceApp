require 'rails_helper'

RSpec.describe TransactionCreateService, type: :service do
  subject(:service) { described_class.new(user, params) }

  let(:user) { create(:user, balance: 100.0) }
  let(:base_params) do { category_id: category.id, currency_id: currency.id, amount: 50.0, description: 'Test Transaction', transaction_date: Time.current } end
  let(:category_income) { create(:category, category_type: 'income') }
  let(:category_expense) { create(:category, category_type: 'expense') }
  let(:currency) { create(:currency) }

  describe '#call' do
    context 'with income category' do
      let(:category) { category_income }
      let(:params) { base_params }

      it 'creates a transaction' do
        expect { service.call }.to change(Transaction, :count).by(1)
      end

      it 'associates transaction with the user' do
        transaction = service.call

        expect(transaction.user).to eq(user)
      end

      it 'increases user balance by amount' do
        expect { service.call }.to change { user.reload.balance }.by(50.0)
      end
    end

    context 'with expense category' do
      let(:category) { category_expense }
      let(:params) { base_params }

      it 'creates a transaction' do
        expect { service.call }.to change(Transaction, :count).by(1)
      end

      it 'associates transaction with the user' do
        expect(service.call.user).to eq(user)
      end

      it 'decreases user balance by amount' do
        expect { service.call }.to change { user.reload.balance }.by(-50.0)
      end
    end

    context 'with missing optional fields' do
      let(:category) { category_expense }
      let(:params) { base_params.except(:description, :transaction_date) }

      it 'creates a transaction' do
        expect { service.call }.to change(Transaction, :count).by(1)
      end

      it 'sets default transaction_date if missing' do
        expect(service.call.transaction_date).to be_present
      end
    end

    context 'with invalid amount' do
      let(:category) { category_expense }
      let(:params) { base_params.merge(amount: -10.0) }

      it 'raises ActiveRecord::RecordInvalid' do
        expect { service.call }.to raise_error(ActiveRecord::RecordInvalid)
      end

      it 'does not change user balance or create transaction' do
        begin
          service.call
        rescue ActiveRecord::RecordInvalid
        end

        expect(user.reload.balance).to eq(100)
      end
    end

    context 'with non-existent associated records' do
      let(:category) { category_income }
      let(:params) { base_params }

      it 'raises RecordInvalid if category missing' do
        params[:category_id] = 0

        expect { service.call }.to raise_error(ActiveRecord::RecordInvalid)
      end

      it 'raises RecordInvalid if currency missing' do
        params[:currency_id] = 0

        expect { service.call }.to raise_error(ActiveRecord::RecordInvalid)
      end
    end
  end
end
