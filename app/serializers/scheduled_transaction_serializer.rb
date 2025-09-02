class ScheduledTransactionSerializer
  include JSONAPI::Serializer

  belongs_to :category
  belongs_to :currency

  attributes :user_id
  attributes :category_id
  attributes :currency_id
  attributes :amount
  attributes :frequency
  attributes :day_of_week
  attributes :day_of_month
  attributes :start_date
  attributes :next_execute_at
  attributes :active
  attributes :updated_at
  attributes :created_at
end
