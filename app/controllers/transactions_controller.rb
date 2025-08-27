class TransactionsController < ApplicationController
    rescue_from ActiveRecord::RecordNotFound, with: :render_not_found
    rescue_from ActiveRecord::RecordInvalid, with: :render_unprocessable_content

    def index
        transactions = current_user.transactions

        render json: transactions, status: :ok
    end

    def show
        transaction = current_user.transactions.find(params[:id])

        render json: transaction, status: :ok
    end

    def create
        service = TransactionCreateService.new(current_user, transaction_params)

        render json: service.call, status: :created
    end

    def update
        transaction = current_user.transactions.find(params[:id])
        service = TransactionUpdateService.new(transaction, transaction_params)

        render json: service.call, status: :ok
    end

    def destroy
        transaction = current_user.transactions.find(params[:id])
        service = TransactionDeleteService.new(transaction)
        service.call

        head :no_content
    end

    private

    def render_not_found(exception)
        render json: { error: exception.message }, status: :not_found
    end

    def render_unprocessable_content(exception)
        render json: { error: exception.record.errors.full_messages }, status: :unprocessable_content
    end

    def transaction_params
        params.expect(transaction: [ :category_id, :currency_id, :amount, :transaction_date, :description ])
    end
end
