class CurrenciesController < ApplicationController
    def index
        currencies = Currency.all
        render json: currencies, status: :ok
    end
end
