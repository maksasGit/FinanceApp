class TransactionsController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :render_not_found
  rescue_from ActiveRecord::RecordInvalid, with: :render_unprocessable_content

  def index
    transactions = current_user.transactions.includes(:category, :currency)

    transactions = TransactionFilterService.new(transactions, params).call

    sort_param, sort_order = parse_sort_params(params[:sort])
    transactions = TransactionSortService.new(transactions, sort_param, sort_order).call if sort_param.present?

    render_jsonapi_response(transactions, include: [ :category, :currency ])
  end

  def show
    transaction = current_user.transactions.includes(:category, :currency).find(params[:id])

    render_jsonapi_response(transaction, include: [ :category, :currency ])
  end

  def create
    service = TransactionCreateService.new(current_user, transaction_params)

    render_jsonapi_response(service.call, include: [ :category, :currency ], status: :created)
  end

  def update
    transaction = current_user.transactions.find(params[:id])
    service = TransactionUpdateService.new(transaction, transaction_params)

    render_jsonapi_response(service.call, include: [ :category, :currency ])
  end

  def destroy
    transaction = current_user.transactions.find(params[:id])
    service = TransactionDeleteService.new(transaction)
    service.call

    head :no_content
  end

  private

  def render_not_found(exception)
    render_jsonapi_error(exception.message, status: :not_found)
  end

  def render_unprocessable_content(exception)
    render_jsonapi_error(exception.record.errors.full_messages, status: :unprocessable_content)
  end

  def parse_sort_params(param)
    return [ nil, nil ] if param.blank?

    if param[0] == "-"
      [ param[1..], :desc ]
    else
      [ param, :asc ]
    end
  end

  def transaction_params
    params.expect(transaction: [ :category_id, :currency_id, :amount, :transaction_date, :description ])
  end
end
