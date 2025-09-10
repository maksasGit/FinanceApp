require 'rails_helper'

TRANSACTION_URL = "/api/v1/transactions".freeze

CURRENT_USER_TRANSACTIONS_SIZE = 3
OTHER_USER_TRNASACTIONS_SIZE = 2

RSpec.describe 'Transactions', type: :request do
  let(:auth_user) { create(:auth_user) }
  let(:token) { JWT.encode({ user_id: auth_user.id }, Rails.application.secret_key_base) }
  let(:headers) { { 'Authorization' => "Bearer #{token}" } }

  let(:category) { create(:category) }
  let(:currency) { create(:currency) }
  let(:current_user) { auth_user }
  let(:other_user) { create(:dynamic_user) }

  before do
    create_list(:dynamic_transaction, CURRENT_USER_TRANSACTIONS_SIZE, user: current_user)
    create_list(:dynamic_transaction, OTHER_USER_TRNASACTIONS_SIZE, user: other_user)
  end

  def json_response
    response.parsed_body[:data]
  end

  describe 'GET /transactions' do
    it 'returns status ok' do
      get TRANSACTION_URL, headers: headers

      expect(response).to have_http_status(:ok)
    end

    it 'returns only transactions belonging to current user' do
      get TRANSACTION_URL, headers: headers

      expect(json_response.size).to eq(CURRENT_USER_TRANSACTIONS_SIZE)
      expect(json_response.all? { |t| t['attributes']['user_id'] == auth_user.id }).to be true
    end
  end

  describe 'GET /transactions/:id' do
    let!(:transaction) { create(:dynamic_transaction, user: current_user) }
    let!(:other_transaction) { create(:dynamic_transaction, user: other_user) }

    it 'returns the transaction if it belongs to the user' do
      get "#{TRANSACTION_URL}/#{transaction.id}", headers: headers

      expect(response).to have_http_status(:ok)
      expect(json_response['id'].to_i).to eq(transaction.id)
    end

    it 'returns 404 if the transaction does not belong to the user' do
      get "#{TRANSACTION_URL}/#{other_transaction.id}", headers: headers

      expect(response).to have_http_status(:not_found)
    end
  end

  describe 'POST /transactions' do
    let(:valid_params) do
      {
        transaction: {
          amount: 50,
          category_id: category.id,
          currency_id: currency.id,
          description: 'Test transaction',
          transaction_date: Time.current
        }
      }
    end

    it 'creates the transaction belonging to current user' do
      expect {
        post TRANSACTION_URL, params: valid_params, headers: headers
      }.to change(Transaction, :count).by(1)

      expect(response).to have_http_status(:created)
      expect(json_response['attributes']['user_id']).to eq(auth_user.id)
    end

    it 'returns errors for invalid data' do
      invalid_params = { transaction: { amount: -20 } }
      post TRANSACTION_URL, params: invalid_params, headers: headers

      expect(response).to have_http_status(:unprocessable_content)
      expect(response.parsed_body['errors']).to be_present
    end
  end

  describe 'PUT /transactions/:id' do
    let!(:transaction) { create(:transaction, user: current_user, category: category, currency: currency, amount: 100) }
    let!(:other_transaction) { create(:transaction, user: other_user, category: category, currency: currency, amount: 100) }
    let(:update_params) do
      {
        transaction: { amount: 75 }
      }
    end

    it 'updates a transaction for current_user' do
      put "#{TRANSACTION_URL}/#{transaction.id}", params: update_params, headers: headers

      expect(response).to have_http_status(:ok)
      expect(transaction.reload.amount).to eq(75)
    end

    it 'returns 404 if transaction not owned' do
      put "#{TRANSACTION_URL}/#{other_transaction.id}", params: update_params, headers: headers

      expect(response).to have_http_status(:not_found)
    end
  end

  describe 'DELETE /transactions/:id' do
    let!(:transaction) { create(:transaction, user: current_user, category: category, currency: currency, amount: 100) }
    let!(:other_transaction) { create(:transaction, user: other_user, category: category, currency: currency, amount: 100) }

    it 'deletes current_user\'s transaction' do
      expect {
        delete "#{TRANSACTION_URL}/#{transaction.id}", headers: headers
      }.to change(Transaction, :count).by(-1)

      expect(response).to have_http_status(:no_content)
    end

    it 'returns 404 for unauthorized transaction' do
      delete "#{TRANSACTION_URL}/#{other_transaction.id}", headers: headers

      expect(response).to have_http_status(:not_found)
    end
  end
end
