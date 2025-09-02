require 'rails_helper'

SCHEDULED_TRANSACTION_URL = "/api/v1/scheduled_transactions".freeze

RSpec.describe "ScheduledTransactions", type: :request do
    let(:current_user) { create(:auth_user) }
    let(:token) { JWT.encode({ user_id: current_user.id }, Rails.application.secret_key_base) }
    let(:headers) { { 'Authorization' => "Bearer #{token}" } }
    let(:other_user) { create(:dynamic_user) }

    def json_response
        response.parsed_body
    end

    describe "GET /scheduled_transactions" do
      before do
        create_list(:scheduled_transaction, 3, user: current_user)
        create_list(:scheduled_transaction, 2, user: other_user)
      end

      it "returns status ok" do
        get SCHEDULED_TRANSACTION_URL, headers: headers

        expect(response).to have_http_status(:ok)
      end

      it "returns all categories belonging to current_user" do
        get SCHEDULED_TRANSACTION_URL, headers: headers

        expect(json_response.size).to eq(3)
        expect(json_response.all? { |t| t["user_id"] == current_user.id }).to be true
      end
    end

    describe "GET /scheduled_transactions/:id" do
      let!(:current_user_scheduled_transaction) { create(:scheduled_transaction, user: current_user) }
      let!(:other_user_scheduled_transaction) { create(:scheduled_transaction, user: other_user) }

      it "returns the category if it belongs to the user" do
        get SCHEDULED_TRANSACTION_URL + "/#{current_user_scheduled_transaction.id}", headers: headers

        expect(response).to have_http_status(:ok)
        expect(json_response["id"]).to eq(current_user_scheduled_transaction.id)
      end

      it "returns 404 if the category does not belong to the user" do
        get SCHEDULED_TRANSACTION_URL + "/#{other_user_scheduled_transaction.id}", headers: headers

        expect(response).to have_http_status(:not_found)
      end
    end

    describe "POST /scheduled_transactions" do
      let(:valid_params) do
      {
        scheduled_transaction: {
          category_id: create(:category).id,
          currency_id: create(:currency).id,
          amount: 100,
          description: "valid desctiption",
          frequency: "weekly",
          day_of_week: 3,
          start_date: 1.day.from_now
        }
      }
      end

      it "creates the category belonging to current user" do
        expect {
          post SCHEDULED_TRANSACTION_URL, params: valid_params, headers: headers
        }.to change(ScheduledTransaction, :count).by(1)

        expect(response).to have_http_status(:created)
        expect(json_response["user_id"]).to eq(current_user.id)
      end

      it 'returns errors for invalid data' do
        invalid_params = { scheduled_transaction: { category_id: 0 } }
        post SCHEDULED_TRANSACTION_URL, params: invalid_params, headers: headers

        expect(response).to have_http_status(:unprocessable_content)
        expect(json_response["error"]).to be_present
      end
    end

    describe "PUT /scheduled_transactions/:id" do
      let!(:current_user_scheduled_transaction) { create(:scheduled_transaction, :weekly, day_of_week: 3, user: current_user) }
      let!(:other_user_scheduled_transaction) { create(:scheduled_transaction, :weekly, day_of_week: 3, user: other_user) }
      let(:valid_update_params) do
      {
        scheduled_transaction: {
          category_id: create(:category).id,
          currency_id: create(:currency).id,
          amount: 100,
          description: "valid desctiption",
          frequency: "monthly",
          day_of_month: 23,
          start_date: 1.day.from_now
        }
      }
      end

      it "updates a category for current_user" do
        put SCHEDULED_TRANSACTION_URL + "/#{current_user_scheduled_transaction.id}", params: valid_update_params, headers: headers
        current_user_scheduled_transaction.reload

        expect(response).to have_http_status(:ok)
      end

      it "returns 404 if category not owned" do
        put "/scheduled_transactions/#{other_user_scheduled_transaction.id}", params: valid_update_params, headers: headers

        expect(response).to have_http_status(:not_found)
      end
    end

    describe "DELETE /scheduled_transactions/:id" do
      let!(:current_user_scheduled_transaction) { create(:scheduled_transaction, :weekly, day_of_week: 3, user: current_user) }
      let!(:other_user_scheduled_transaction) { create(:scheduled_transaction, :weekly, day_of_week: 3, user: other_user) }

      it "deletes current_user's scheduled_transactions" do
        expect {
          delete SCHEDULED_TRANSACTION_URL + "/#{current_user_scheduled_transaction.id}", headers: headers
        }.to change(ScheduledTransaction, :count).by(-1)

        expect(response).to have_http_status(:no_content)
      end

      it "returns 404 for unauthorized category" do
        delete SCHEDULED_TRANSACTION_URL + "/#{other_user_scheduled_transaction.id}", headers: headers

        expect(response).to have_http_status(:not_found)
      end
    end
end
