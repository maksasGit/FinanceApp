class ScheduledTransactionJob
  include Sidekiq::Worker

  def perform
    ScheduledTransaction.where(active: true)
                        .where(next_execute_at: ..Time.current)
                        .find_each do |scheduled_tx|
      begin
        ActiveRecord::Base.transaction do
          Rails.logger.info "Start create scheduled transactin ##{scheduled_tx.id}..."
          transaction_user = User.find(scheduled_tx.user.id)
          transaction_params = {
            category_id: scheduled_tx.category_id,
            currency_id: scheduled_tx.currency_id,
            amount: scheduled_tx.amount,
            description: scheduled_tx.description
          }
          service = TransactionCreateService.new(transaction_user, transaction_params)
          service.call

          next_time = calculate_next_execute_at(scheduled_tx)

          if next_time.nil?
            scheduled_tx.update!(active: false)
            Rails.logger.info "Scheduled Transaction ##{scheduled_tx.id} was updated with active status false"
          else
            scheduled_tx.update!(next_execute_at: next_time)
            Rails.logger.info "Scheduled Transaction ##{scheduled_tx.id} was updated with next_execute_at: #{next_time}"
          end
        end
      rescue => e
        Rails.logger.error "Unexpected Error on processing ScheduledTransaction ##{scheduled_tx.id}: #{e.message}"
      end
    end
  end

  def calculate_next_execute_at(scheduled_tx)
    next_time = case scheduled_tx.frequency
    when "once" then nil
    when "daily" then scheduled_tx.next_execute_at + 1.day
    when "weekly" then scheduled_tx.next_execute_at + 1.week
    when "monthly" then scheduled_tx.next_execute_at + 1.month
    else nil
    end

    if scheduled_tx.end_date && next_time && next_time > scheduled_tx.end_date
      nil
    else
      next_time
    end
  end
end
