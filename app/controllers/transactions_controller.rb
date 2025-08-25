class TransactionsController < ApplicationController
    def index
        transactions = Transaction.all
        render json: transactions, status: :ok
    end

    def show
        transaction = Transaction.find(params[:id])
        render json: transaction, status: :ok
    end

    def create
        transaction = Transaction.new(transaction_params)
        if transaction.save
            render json: transaction, status: :created
        else
            render json: { errors: transaction.errors.full_messages }, status: :unprocessable_content
        end
    end

    private

    def transaction_params
        params.expect(transaction: [ :user_id, :category_id, :currency_id, :amount, :transaction_date, :description ])
    end
end
