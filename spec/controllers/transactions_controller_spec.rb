require 'rails_helper'

RSpec.describe TransactionsController, type: :controller do
    describe "GET #index" do
        before do
            create_list(:dynamic_transaction, 3)
            get :index
        end

        it "returns http success" do
            expect(response).to have_http_status(:ok)
        end

        it "returns all transactions" do
            expect(response.parsed_body.size).to eq(3)
        end
    end

    describe "GET #show" do
        let(:transaction) { create(:transaction) }

        before do
            get :show, params: { id: transaction.id }
        end

        it "returns http success" do
            expect(response).to have_http_status(:ok)
        end

        it "returns the correct transactions" do
            returned_transaction = response.parsed_body
            expect(returned_transaction["id"]).to eq(transaction.id)
        end
    end

    describe "POST #create" do
        context "with valid params" do
            let(:valid_attributes) { build(:transaction_with_associations).attributes }

            it "creates a new transaction" do
                puts valid_attributes
                expect {
                    post :create, params: { transaction: valid_attributes }
                }.to change(Transaction, :count).by(1)
            end

            it "returns http created" do
                post :create, params: { transaction: valid_attributes }

                expect(response).to have_http_status(:created)
            end

            it "returns the created transaction" do
                post :create, params: { transaction: valid_attributes }

                returned_transaction = response.parsed_body
                expect(returned_transaction["description"]).to eq(valid_attributes["description"])
            end
        end

        context "with invalid params" do
            let(:invalid_attributes) { build(:invalid_transaction).attributes }

            it "does not create a new transaction" do
                expect {
                    post :create, params: { transaction:  invalid_attributes }
                }.not_to change(Transaction, :count)
            end

            it "returns http unprocessable_content" do
                post :create, params: { transaction:  invalid_attributes }
                expect(response).to have_http_status(:unprocessable_content)
            end
        end
    end
end
