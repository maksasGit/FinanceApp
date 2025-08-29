class ScheduledTransactionUpdateService
  def initialize(scheduled_transaction, scheduled_transaction_params)
    @scheduled_transaction = scheduled_transaction
    @scheduled_transaction_params = scheduled_transaction_params
  end

  def call
    ActiveRecord::Base.transaction do
      @scheduled_transaction.assign_attributes(@scheduled_transaction_params)

      case @scheduled_transaction_params[:frequency]
      when "once"
        @scheduled_transaction.day_of_week = nil
        @scheduled_transaction.day_of_month = nil
      when "weekly"
        @scheduled_transaction.day_of_month = nil
      when "monthly"
        @scheduled_transaction.day_of_week = nil
      end

      @scheduled_transaction.save!
    end

    @scheduled_transaction
  end
end
