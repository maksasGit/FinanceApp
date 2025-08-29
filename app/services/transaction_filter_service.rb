class TransactionFilterService
  def initialize(transactions, filter_params)
    @transactions = transactions
    @filter_params = filter_params
  end

  def call
    filter_by_dates
    filter_by_amount
    filter_by_category_type

    @transactions
  end

  private

  def filter_by_dates
    start_date = @filter_params[:start_date]
    end_date = @filter_params[:end_date]
    @transactions = @transactions.where(transaction_date: start_date..) if start_date.present?
    @transactions = @transactions.where(transaction_date: ..end_date) if end_date.present?
  end

  def filter_by_amount
    min_amount = @filter_params[:min_amount]
    max_amount = @filter_params[:max_amount]
    @transactions = @transactions.where(amount: min_amount.to_f..) if min_amount.present?
    @transactions = @transactions.where(amount: ..max_amount.to_f)  if max_amount.present?
  end

  def filter_by_category_type
    category_type = @filter_params[:category_type]
    @transactions = @transactions.joins(:category).where(categories: { category_type: category_type }) if category_type.present?
  end
end
