require 'rails_helper'

RSpec.describe UsersController, type: :controller do
    describe "GET #index" do
        before do
            create_list(:dynamic_user, 3)
            get :index
        end

        it "returns http success" do
            expect(response).to have_http_status(:ok)
        end

        it "returns all users" do
            expect(response.parsed_body.size).to eq(3)
        end
    end

    describe "GET #show" do
        let(:user) { create(:user) }

        before do
            get :show, params: { id: user.id }
        end

        it "returns http success" do
            expect(response).to have_http_status(:ok)
        end

        it "returns the correct user" do
            returned_user = response.parsed_body
            expect(returned_user["id"]).to eq(user.id)
        end
    end

    describe "POST #create" do
        context "with valid params" do
            let(:valid_attributes) { build(:user).attributes }

            it "creates a new user" do
                expect {
                    post :create, params: { user: valid_attributes }
                }.to change(User, :count).by(1)
            end

            it "returns http created" do
                post :create, params: { user: valid_attributes }

                expect(response).to have_http_status(:created)
            end

            it "returns the created user" do
                post :create, params: { user: valid_attributes }

                returned_user = response.parsed_body
                expect(returned_user["email"]).to eq(valid_attributes["email"])
            end
        end

        context "with invalid params" do
            let(:invalid_attributes) { build(:invalid_user).attributes }

            it "does not create a new user" do
                expect {
                    post :create, params: { user:  invalid_attributes }
                }.not_to change(User, :count)
            end

            it "returns http unprocessable_content" do
                post :create, params: { user:  invalid_attributes }
                expect(response).to have_http_status(:unprocessable_content)
            end
        end
    end
end
