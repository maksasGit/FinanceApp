require 'rails_helper'

RSpec.describe "Users", type: :request do
  describe "GET /users" do
    before do
      create_list(:dynamic_user, 3)
    end

    it "returns status ok" do
      get "/users"

      expect(response).to have_http_status(:ok)
    end

    it "returns all users" do
      get "/users"

      expect(response.parsed_body.size).to eq(3)
    end
  end
end
