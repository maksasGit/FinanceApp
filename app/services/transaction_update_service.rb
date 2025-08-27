class TransactionUpdateService
    def initialize(transaction, transaction_params)
        @transaction = transaction
        @transaction_params = transaction_params
        @user = @transaction.user
        @errors = []
    end

    def call
        ActiveRecord::Base.transaction do
            previous_amount = @transaction.amount_adjustment
            @transaction.assign_attributes(@transaction_params)
            current_amount = @transaction.amount_adjustment

            @user.balance -= previous_amount
            @user.balance += current_amount

            @transaction.save!
            @user.save!
        end

        @transaction
    end
end
