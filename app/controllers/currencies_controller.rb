class CurrenciesController < ApplicationController
    def index
        currencies = Currency.all
        render json: currencies, status: :ok
    end

    def show
        currency = Currency.find(params[:id])
        render json: currency, status: :ok
    end

    def create
        currency = Currency.new(currency_params)
        if currency.save
            render json: currency, status: :created
        else
            render json: { errors: currency.errors.full_messages }, status: :unprocessable_content
        end
    end

    private

    def currency_params
        params.expect(currency: [ :code, :name ])
    end
end
