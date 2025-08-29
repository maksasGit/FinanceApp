# require 'rails_helper'

# RSpec.describe UsersController, type: :controller do
#     before do
#         allow(controller).to receive(:authorized).and_return(true)
#     end

#     describe "GET #index" do
#         before do
#             create_list(:dynamic_user, 3)
#             get :index
#         end

#         it "returns http success" do
#             expect(response).to have_http_status(:ok)
#         end

#         it "returns all users" do
#             expect(response.parsed_body.size).to eq(3)
#         end
#     end

#     describe "GET #show" do
#         let(:user) { create(:user) }

#         before do
#             get :show, params: { id: user.id }
#         end

#         it "returns http success" do
#             expect(response).to have_http_status(:ok)
#         end

#         it "returns the correct user" do
#             returned_user = response.parsed_body
#             expect(returned_user["id"]).to eq(user.id)
#         end
#     end

#     describe "POST #create" do
#         context "with valid params" do
#             let(:valid_attributes) do
#                 {
#                     name: "John Doe",
#                     email: "john@example.com",
#                     password: "password123",
#                     password_confirmation: "password123"
#                 }
#                 end

#             it "creates a new user" do
#                 expect {
#                     post :create, params: { user: valid_attributes }
#                 }.to change(User, :count).by(1)
#             end

#             it "returns http created" do
#                 post :create, params: { user: valid_attributes }

#                 expect(response).to have_http_status(:created)
#             end

#             it "returns the created user" do
#                 post :create, params: { user: valid_attributes }

#                 returned_user = response.parsed_body
#                 expect(returned_user["email"]).to eq(valid_attributes["email"])
#             end
#         end

#         context "with invalid params" do
#             let(:invalid_attributes) { build(:invalid_user).attributes }

#             it "does not create a new user" do
#                 expect {
#                     post :create, params: { user:  invalid_attributes }
#                 }.not_to change(User, :count)
#             end

#             it "returns http unprocessable_content" do
#                 post :create, params: { user:  invalid_attributes }
#                 expect(response).to have_http_status(:unprocessable_content)
#             end
#         end
#     end

#     describe "PUT #update" do
#         let(:user) { create(:user) }

#         context "with valid params" do
#             let(:new_attributes) { { name: "New Name", email: "new@example.com" } }

#             it "updates the requested user" do
#                 put :update, params: { id: user.id, user: new_attributes }

#                 user.reload
#                 expect(user.email).to eq("new@example.com")
#             end

#             it "returns http success" do
#                 put :update, params: { id: user.id, user: new_attributes }

#                 expect(response).to have_http_status(:ok)
#             end

#             it "returns the updated user" do
#                 put :update, params: { id: user.id, user: new_attributes }

#                 body = response.parsed_body
#                 expect(body["email"]).to eq("new@example.com")
#             end
#         end

#         context "with invalid params" do
#             let(:invalid_attributes) { { email: nil } }

#             it "does not update the user" do
#                 put :update, params: { id: user.id, user: invalid_attributes }

#                 user.reload
#                 expect(user.email).not_to be_nil
#             end

#             it "returns unprocessable_entity status" do
#                 put :update, params: { id: user.id, user: invalid_attributes }

#                 expect(response).to have_http_status(:unprocessable_content)
#             end

#             it "returns validation errors" do
#                 put :update, params: { id: user.id, user: invalid_attributes }

#                 body = response.parsed_body
#                 expect(body["errors"]).to include("Email can't be blank")
#             end
#         end

#         context "when user not found" do
#             it "returns 404 not found" do
#                 put :update, params: { id: 0, user: { name: "Test" } }

#                 expect(response).to have_http_status(:not_found)
#             end
#         end
#     end

#     describe "DELETE #destroy" do
#         let!(:user) { create(:user) }

#         it "deletes the user" do
#             expect {
#                 delete :destroy, params: { id: user.id }
#             }.to change(User, :count).by(-1)
#        end

#         it "returns no content status" do
#             delete :destroy, params: { id: user.id }

#             expect(response).to have_http_status(:no_content)
#         end

#         context "when user not found" do
#             it "returns 404 not found" do
#                 delete :destroy, params: { id: 0 }

#                 expect(response).to have_http_status(:not_found)
#             end
#         end
#     end
# end
