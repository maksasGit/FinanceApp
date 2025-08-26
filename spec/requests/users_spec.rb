require 'rails_helper'

RSpec.describe "Users", type: :request do
  let(:user) { create(:user) }
  let(:token) { JWT.encode({ user_id: user.id }, Rails.application.secret_key_base) }
  let(:headers) { { 'Authorization' => "Bearer #{token}" } }

  describe "GET /users" do
    before do
      create_list(:dynamic_user, 3)
    end

    it "returns status ok" do
      get "/users", headers: headers

      expect(response).to have_http_status(:ok)
    end

    it "returns all users" do
      get "/users", headers: headers

      expect(response.parsed_body.size).to eq(4) # with auth user
    end
  end
end
