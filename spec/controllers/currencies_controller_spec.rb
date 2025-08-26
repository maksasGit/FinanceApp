require 'rails_helper'

RSpec.describe CurrenciesController, type: :controller do
    before do
        allow(controller).to receive(:authorized).and_return(true)
    end

    describe "GET #index" do
        before do
            create_list(:dynamic_currency, 3)
            get :index
        end

        it "returns http success" do
            expect(response).to have_http_status(:ok)
        end

        it "returns all currencies" do
            expect(response.parsed_body.size).to eq(3)
        end
    end

    describe "GET #show" do
        let(:currency) { create(:currency) }

        before do
            get :show, params: { id: currency.id }
        end

        it "returns http success" do
            expect(response).to have_http_status(:ok)
        end

        it "returns the correct currency" do
            returned_currency = response.parsed_body
            expect(returned_currency["id"]).to eq(currency.id)
        end
    end

    describe "POST #create" do
        context "with valid params" do
            let(:valid_attributes) { build(:currency).attributes }

            it "creates a new currency" do
                expect {
                    post :create, params: { currency: valid_attributes }
                }.to change(Currency, :count).by(1)
            end

            it "returns http created" do
                post :create, params: { currency: valid_attributes }

                expect(response).to have_http_status(:created)
            end

            it "returns the created currency" do
                post :create, params: { currency: valid_attributes }

                returned_currency = response.parsed_body
                expect(returned_currency["code"]).to eq(valid_attributes["code"])
            end
        end

        context "with invalid params" do
            let(:invalid_attributes) { build(:invalid_currency).attributes }

            it "does not create a new currency" do
                expect {
                    post :create, params: { currency:  invalid_attributes }
                }.not_to change(Currency, :count)
            end

            it "returns http unprocessable_content" do
                post :create, params: { currency:  invalid_attributes }
                expect(response).to have_http_status(:unprocessable_content)
            end
        end
    end
end
