class TransactionSerializer
  include JSONAPI::Serializer

  belongs_to :category
  belongs_to :currency

  attributes :amount
  attributes :user_id
  attributes :category_id
  attributes :currency_id
  attributes :description
  attributes :transaction_date
  attributes :updated_at
  attributes :created_at
end
