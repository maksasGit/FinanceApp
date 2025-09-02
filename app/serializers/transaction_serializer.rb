class TransactionSerializer
  include JSONAPI::Serializer
  attributes :amount, :user_id, :category_id, :currency_id, :description, :transaction_date, :updated_at, :created_at

  belongs_to :category
  belongs_to :currency
end
