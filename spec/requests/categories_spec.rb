require 'rails_helper'

CATEGORIES_URL = "/api/v1/categories".freeze

RSpec.describe "Categories", type: :request do
  let(:current_user) { create(:auth_user) }
  let(:token) { JWT.encode({ user_id: current_user.id }, Rails.application.secret_key_base) }
  let(:headers) { { 'Authorization' => "Bearer #{token}" } }

  let(:other_user) { create(:dynamic_user) }

  def json_response
    response.parsed_body
  end

  describe "GET /categories" do
    before do
      create_list(:dynamic_category, 3, user: current_user)
      create_list(:dynamic_category, 2, user: other_user)
    end

    it "returns status ok" do
      get CATEGORIES_URL, headers: headers

      expect(response).to have_http_status(:ok)
    end

    it "returns all categories belonging to current_user" do
      get CATEGORIES_URL, headers: headers

      expect(json_response.size).to eq(3)
      expect(json_response.all? { |t| t["user_id"] == current_user.id }).to be true
    end

    it "returns all categories belonging to current_user + default with user equal nil" do
      create_list(:category, 5) # with no user
      get CATEGORIES_URL, headers: headers

      expect(json_response.size).to eq(3 + 5)
      end
    end

  describe "GET /categories/:id" do
    let!(:current_user_category) { create(:dynamic_category, user: current_user) }
    let!(:other_user_category) { create(:dynamic_category, user: other_user) }

    it "returns the category if it belongs to the user" do
      get CATEGORIES_URL + "/#{current_user_category.id}", headers: headers

      expect(response).to have_http_status(:ok)
      expect(json_response["id"]).to eq(current_user_category.id)
    end

    it "returns 404 if the category does not belong to the user" do
      get CATEGORIES_URL + "/#{other_user_category.id}", headers: headers

      expect(response).to have_http_status(:not_found)
    end
  end

  describe "POST /categories" do
    let!(:parent_category) { create(:dynamic_category, user: current_user) }
    let(:valid_params) do
    {
      category: {
        parent_id: parent_category.id,
        name: "Valid name",
        category_type: parent_category.category_type
      }
    }
    end

    it "creates the category belonging to current user" do
      expect {
        post CATEGORIES_URL, params: valid_params, headers: headers
      }.to change(Category, :count).by(1)

      expect(response).to have_http_status(:created)
      expect(json_response["user_id"]).to eq(current_user.id)
    end

    it 'returns unprocessable_content for not existing record' do
      invalid_params = { category: { parent_id: 0 } }
      post CATEGORIES_URL, params: invalid_params, headers: headers

      expect(response).to have_http_status(:unprocessable_content)
      expect(json_response["error"]).to be_present
    end

    it 'returns unprocessable_content for invalid data' do
      invalid_params = { category: { name: "", category_type: "invalid_type" } }
      post CATEGORIES_URL, params: invalid_params, headers: headers

      expect(response).to have_http_status(:unprocessable_content)
    end

  it 'returns unprocessable_content for data when parent_id category assigned to antoher user' do
      other_user_category = create(:dynamic_category, user: other_user)
      forbidden_params = valid_params
      forbidden_params[:category][:parent_id] = other_user_category.id
      post '/api/v1/categories', params: forbidden_params, headers: headers

      expect(response).to have_http_status(:unprocessable_content)
    end
  end

  describe "PUT /categories/:id" do
    let!(:parent_category) { create(:dynamic_category, user: current_user) }
    let!(:current_user_category) { create(:dynamic_category, user: current_user) }
    let!(:other_user_category) { create(:dynamic_category, user: other_user) }
    let(:valid_update_params) do
    {
      category: {
        parent_id: parent_category.id,
        name: "Valid name",
        category_type: current_user_category.category_type
      }
    }
    end

    it "updates a category for current_user" do
      put CATEGORIES_URL + "/#{current_user_category.id}", params: valid_update_params, headers: headers
      current_user_category.reload

      expect(response).to have_http_status(:ok)
      expect(current_user_category.parent.id).to eq(parent_category.id)
    end

    it "returns 404 if category not owned" do
      put CATEGORIES_URL + "/#{other_user_category.id}", params: valid_update_params, headers: headers

      expect(response).to have_http_status(:not_found)
    end
  end

  describe "DELETE /categories/:id" do
    let!(:current_user_category) { create(:dynamic_category, user: current_user) }
    let!(:other_user_category) { create(:dynamic_category, user: other_user) }

    it "deletes current_user's category" do
      expect {
        delete CATEGORIES_URL + "/#{current_user_category.id}", headers: headers
      }.to change(Category, :count).by(-1)

      expect(response).to have_http_status(:no_content)
    end

    it "returns 404 for unauthorized category" do
      delete CATEGORIES_URL + "/#{other_user_category.id}", headers: headers

      expect(response).to have_http_status(:not_found)
    end
  end
end
