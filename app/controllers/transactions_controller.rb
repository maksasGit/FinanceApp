class TransactionsController < ApplicationController
    rescue_from ActiveRecord::RecordNotFound, with: :render_not_found

    def index
        transactions = Transaction.all
        render json: transactions, status: :ok
    end

    def show
        transaction = Transaction.find(params[:id])
        render json: transaction, status: :ok
    end

    def create
        user = User.find(transaction_params[:user_id])
        category = Category.find(transaction_params[:category_id])

        service = TransactionCreateService.new(user, category, transaction_params)

        if service.call
            render json: service.transaction, status: :created
        else
            render json: { errors: service.errors }, status: :unprocessable_content
        end
    end

    private

    def render_not_found(exception)
        render json: { error: exception.message }, status: :unprocessable_content
    end

    def transaction_params
        params.expect(transaction: [ :user_id, :category_id, :currency_id, :amount, :transaction_date, :description ])
    end
end
