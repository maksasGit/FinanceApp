class TransactionSortService
    POSSIBLE_PARAMS = %w[amount transaction_date].freeze

    def initialize(transactions, sort_param, sort_order)
      @transactions = transactions
      @sort_param = sort_param
      @sort_order = sort_order || :asc
    end

    def call
      @sort_param = POSSIBLE_PARAMS.include?(@sort_param) ? @sort_param : "transaction_date"

      @transactions.order(@sort_param => @sort_order)
    end
end
