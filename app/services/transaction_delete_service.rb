class TransactionDeleteService
  def initialize(transaction)
    @transaction = transaction
    @user = transaction.user
  end

  def call
    ActiveRecord::Base.transaction do
      @user.balance -= @transaction.amount_adjustment

      @user.save!
      @transaction.destroy!
    end

    true
  end
end
