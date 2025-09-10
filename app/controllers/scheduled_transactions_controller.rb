class ScheduledTransactionsController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :render_not_found
  rescue_from ActiveRecord::RecordInvalid, with: :render_unprocessable_content

  def index
    scheduled_transactions = current_user.scheduled_transactions

    render_jsonapi_response(scheduled_transactions)
  end

  def show
    scheduled_transaction = current_user.scheduled_transactions.find(params[:id])

    render_jsonapi_response(scheduled_transaction)
  end

  def create
    scheduled_transaction = current_user.scheduled_transactions.new(scheduled_transaction_params)
    scheduled_transaction.save!

    render_jsonapi_response(scheduled_transaction, status: :created)
  end

  def update
    scheduled_transaction = current_user.scheduled_transactions.find(params[:id])
    service = ScheduledTransactionUpdateService.new(scheduled_transaction, scheduled_transaction_params)

    render_jsonapi_response(service.call)
  end

  def destroy
    scheduled_transaction = current_user.scheduled_transactions.find(params[:id])
    scheduled_transaction.destroy!

    head :no_content
  end

  private

  def render_not_found(exception)
    render_jsonapi_error(exception.message, status: :not_found)
  end

  def render_unprocessable_content(exception)
    render_jsonapi_error(exception.record.errors.full_messages, status: :unprocessable_content)
  end

  def scheduled_transaction_params
    params.expect(scheduled_transaction: [ :category_id, :currency_id, :amount, :description, :frequency, :start_date, :active, :day_of_week, :day_of_month ])
  end
end
