class CurrenciesController < ApplicationController
    rescue_from ActiveRecord::RecordNotFound, with: :render_not_found
    rescue_from ActiveRecord::RecordInvalid, with: :render_unprocessable_content

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
        currency.save!

        render json: currency, status: :created
    end

    def update
        currency = Currency.find(params[:id])
        currency.update!(currency_params)

        render json: currency, status: :ok
    end

    def destroy
        currency = Currency.find(params[:id])
        currency.destroy!

        head :no_content
    end

    private

    def render_not_found(exception)
        render json: { error: exception.message }, status: :not_found
    end

    def render_unprocessable_content(exception)
        render json: { error: exception.record.errors.full_messages }, status: :unprocessable_content
    end

    def currency_params
        params.expect(currency: [ :code, :name ])
    end
end
