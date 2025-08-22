require 'rails_helper'

RSpec.describe "Transactions", type: :request do
  describe "GET /transactions" do
    before do
      create_list(:dynamic_transaction, 3)
    end

    it "returns status ok" do
      get "/transactions"

      expect(response).to have_http_status(:ok)
    end

    it "returns all transactions" do
      get "/transactions"

      expect(response.parsed_body.size).to eq(3)
    end
  end
end
