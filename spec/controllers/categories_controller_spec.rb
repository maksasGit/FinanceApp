require 'rails_helper'

RSpec.describe CategoriesController, type: :controller do
    describe "GET #index" do
        before do
            create_list(:dynamic_category, 3)
            get :index
        end

        it "returns http success" do
            expect(response).to have_http_status(:ok)
        end

        it "returns all categories" do
            expect(response.parsed_body.size).to eq(3)
        end
    end

    describe "GET #show" do
        let(:category) { create(:category) }

        before do
            get :show, params: { id: category.id }
        end

        it "returns http success" do
            expect(response).to have_http_status(:ok)
        end

        it "returns the correct categories" do
            returned_category = response.parsed_body
            expect(returned_category["id"]).to eq(category.id)
        end
    end

     describe "POST #create" do
        context "with valid params" do
            let(:valid_attributes) { build(:category).attributes }

            it "creates a new category" do
                expect {
                    post :create, params: { category: valid_attributes }
                }.to change(Category, :count).by(1)
            end

            it "returns http created" do
                post :create, params: { category: valid_attributes }

                expect(response).to have_http_status(:created)
            end

            it "returns the created category" do
                post :create, params: { category: valid_attributes }

                returned_category = response.parsed_body
                expect(returned_category["name"]).to eq(valid_attributes["name"])
            end
        end

        context "with invalid params" do
            let(:invalid_attributes) { build(:invalid_category).attributes }

            it "does not create a new category" do
                expect {
                    post :create, params: { category:  invalid_attributes }
                }.not_to change(Category, :count)
            end

            it "returns http unprocessable_content" do
                post :create, params: { category:  invalid_attributes }
                expect(response).to have_http_status(:unprocessable_content)
            end
        end
    end
end
