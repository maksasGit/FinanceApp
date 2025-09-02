require 'rails_helper'

CURRENCY_URL = "/api/v1/currencies".freeze

RSpec.describe "Currencies", type: :request do
  let(:user) { create(:user) }
  let(:token) { JWT.encode({ user_id: user.id }, Rails.application.secret_key_base) }
  let(:headers) { { 'Authorization' => "Bearer #{token}" } }

  def json_response
    response.parsed_body
  end

  describe "GET /currencies" do
    before do
      create_list(:dynamic_currency, 3)
    end

    it "returns status ok" do
      get CURRENCY_URL, headers: headers

      expect(response).to have_http_status(:ok)
      expect(response.parsed_body.size).to eq(3)
    end
  end

  describe "GET /currencies/:id" do
    let!(:get_currency) { create(:dynamic_currency) }

    it "returns status ok" do
      get CURRENCY_URL + "/#{get_currency.id}", headers: headers

      expect(response).to have_http_status(:ok)
      expect(json_response["id"]).to eq(get_currency.id)
    end

    it "returns 404 if the currency does not exist" do
      get CURRENCY_URL + "/#{0}", headers: headers

      expect(response).to have_http_status(:not_found)
    end
  end

  describe "POST /currencies" do
    let(:valid_params) do
      {
        currency: {
          code: "Valid code",
          name: "Valid name",
          decimal_places: 2
        }
      }
    end

    it "returns status created" do
      post CURRENCY_URL, params: valid_params, headers: headers

      expect(response).to have_http_status(:created)
      expect(json_response["name"]).to eq(valid_params[:currency][:name])
    end

    it "returns errors for invalid data" do
      invalid_params = { currency: { code: nil, decimal_places: -2 } }
      post CURRENCY_URL, params: invalid_params, headers: headers

      expect(response).to have_http_status(:unprocessable_content)
    end
  end

  describe "PUT /currencies" do
    let!(:get_currency) { create(:dynamic_currency) }
    let(:valid_params) do
      {
        currency: {
          code: "Valid code",
          name: "Valid name",
          decimal_places: 2
        }
      }
    end

    it "returns status ok" do
      put CURRENCY_URL + "/#{get_currency.id}", params: valid_params, headers: headers

      expect(response).to have_http_status(:ok)
      expect(json_response["id"]).to eq(get_currency.id)
    end

    it "returns errors for invalid id" do
      put CURRENCY_URL + "/#{0}", params: valid_params, headers: headers

      expect(response).to have_http_status(:not_found)
    end
  end

  describe "DELETE /currencies/:id" do
    let!(:get_currency) { create(:dynamic_currency) }

    it "deletes currency" do
      expect {
        delete CURRENCY_URL + "/#{get_currency.id}", headers: headers
      }.to change(Currency, :count).by(-1)

      expect(response).to have_http_status(:no_content)
    end

    it "returns 404 errors for invalid data" do
      delete CURRENCY_URL + "/#{0}", headers: headers

      expect(response).to have_http_status(:not_found)
    end
  end
end
