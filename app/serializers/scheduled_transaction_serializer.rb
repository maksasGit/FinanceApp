class ScheduledTransactionSerializer
  include JSONAPI::Serializer
  attributes :user_id, :category_id, :currency_id, :category_id, :amount, :frequency, :day_of_week, :day_of_month, :start_date, :next_execute_at, :active, :updated_at, :created_at

  belongs_to :category
  belongs_to :currency
end
