require 'rails_helper'

RSpec.describe "Currencies", type: :request do
  let(:user) { create(:user) }
  let(:token) { JWT.encode({ user_id: user.id }, Rails.application.secret_key_base) }
  let(:headers) { { 'Authorization' => "Bearer #{token}" } }

  describe "GET /currencies" do
    before do
      create_list(:dynamic_currency, 3)
    end

    it "returns status ok" do
      get "/currencies", headers: headers

      expect(response).to have_http_status(:ok)
    end

    it "returns all currencies" do
      get "/currencies", headers: headers

      expect(response.parsed_body.size).to eq(3)
    end
  end
end
