require 'rails_helper'

RSpec.describe "Currencies", type: :request do
    describe "GET /currencies" do
    before do
      create_list(:dynamic_currency, 3)
    end

    it "returns status ok" do
      get "/currencies"

      expect(response).to have_http_status(:ok)
    end

    it "returns all currencies" do
      get "/currencies"

      expect(response.parsed_body.size).to eq(3)
    end
  end
end
