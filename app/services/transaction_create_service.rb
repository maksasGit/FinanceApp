class TransactionCreateService
    attr_reader :transaction, :errors

    def initialize(user, category, transaction_params)
        @user = user
        @category = category
        @transaction_params = transaction_params
        @transaction = nil
        @errors = []
    end

    def call
        ActiveRecord::Base.transaction do
            @transaction = @user.transactions.new(@transaction_params)
            amount = @transaction.amount * (@category.category_type == "income" ? 1 : -1)

            @user.balance += amount

            unless @user.save
                @errors.concat(@user.errors.full_messages)
                raise ActiveRecord::Rollback
            end

            unless @transaction.save
                @errors.concat(@transaction.errors.full_messages)
                raise ActiveRecord::Rollback
            end
        end

        errors.empty?
    end
end
