require 'rails_helper'

RSpec.describe "Categories", type: :request do
  describe "GET /categories" do
    before do
      create_list(:dynamic_category, 3)
    end

    it "returns all categories" do
      get "/categories"
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body).size).to eq(3)
    end
  end
end
