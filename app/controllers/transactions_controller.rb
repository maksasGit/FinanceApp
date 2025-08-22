class TransactionsController < ApplicationController
    def index
        transactions = Transaction.all
        render json: transactions, status: :ok
    end
end
