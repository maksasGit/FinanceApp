require 'rails_helper'

URL = "/api/v1/users".freeze

RSpec.describe "Users", type: :request do
  let(:current_user) { create(:auth_user) }
  let(:token) { JWT.encode({ user_id: current_user.id }, Rails.application.secret_key_base) }
  let(:headers) { { 'Authorization' => "Bearer #{token}" } }

  let(:valid_params) do
    {
      user: {
        name: "valid_name",
        email: "valid@email",
        password: "validpassword"
      }
    }
  end

  let(:invalid_params) do
    {
      user: {
        name: "",
        email: nil,
        password: "1"
      }
    }
  end

  def json_response
    response.parsed_body[:data]
  end

  describe "GET /users" do
    before do
      create_list(:dynamic_user, 3)
    end

    it "returns status ok" do
      get URL, headers: headers

      expect(response).to have_http_status(:ok)
    end

    it "returns all users" do
      get URL, headers: headers

      expect(json_response.size).to eq(3 + 1) # 3 dynamic_user + 1 current_user
    end
  end

  describe "GET /users/:id" do
    it "returns status ok" do
      get URL + "/#{current_user.id}", headers: headers

      expect(response).to have_http_status(:ok)
    end

    it "returns 404 if no such user" do
       get URL + "#{0}", headers: headers

      expect(response).to have_http_status(:not_found)
    end
  end

  describe "POST /users" do
    it "returns status created" do
      post URL, params: valid_params, headers: headers

      expect(response).to have_http_status(:created)
    end

    it "returns unprocessable_content" do
      post URL, params: invalid_params, headers: headers

      expect(response).to have_http_status(:unprocessable_content)
    end
  end

  describe "PUT /users/:id" do
    it "returns status ok" do
      put URL + "/#{current_user.id}", params: valid_params, headers: headers

      expect(response).to have_http_status(:ok)
    end

    it "returns status not_found" do
      put URL + "/#{0}", params: valid_params, headers: headers

      expect(response).to have_http_status(:not_found)
    end

    it "returns status unprocessable_content" do
      put URL + "/#{current_user.id}", params: invalid_params, headers: headers

      expect(response).to have_http_status(:unprocessable_content)
    end
  end

  describe "DELETE /users/:id" do
    it "returns status no_content" do
      delete URL + "/#{current_user.id}", params: valid_params, headers: headers

      expect(response).to have_http_status(:no_content)
    end

    it "returns status not_found" do
      delete URL + "/#{0}", headers: headers

      expect(response).to have_http_status(:not_found)
    end
  end
end
