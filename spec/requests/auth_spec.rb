require 'rails_helper'

AUTH_URL = "/api/v1/auth/login".freeze

RSpec.describe "Auths", type: :request do
  let!(:user) { create(:user, password: 'password123') }

  describe "POST /auth/login" do
    context "with valid credentials" do
      it "returns an auth token" do
        post AUTH_URL, params: { auth: { email: user.email, password: 'password123' } }

        expect(response.parsed_body).to have_key('token')
      end
    end

    context "with invalid password" do
      it "returns unauthorized" do
        post AUTH_URL, params: { auth: { email: user.email,  password: 'wrongpass' } }

        expect(response.parsed_body["errors"][0]["detail"]).to eq('Incorrect password')
      end
    end

    context "with non-existing email" do
      it "returns unauthorized" do
        post AUTH_URL, params: { auth: { email: 'nonexisting@example.com',  password: 'password123' } }

        expect(response).to have_http_status(:unauthorized).or(:not_found)
      end
    end
  end
end
