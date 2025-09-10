class TransactionCreateService
  def initialize(user, transaction_params)
    @user = user
    @transaction = @user.transactions.new(transaction_params)
  end

  def call
    ActiveRecord::Base.transaction do
      @user.balance += @transaction.amount_adjustment

      @user.save!
      @transaction.save!
    end

    @transaction
  end
end
