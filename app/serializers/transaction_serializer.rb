class TransactionSerializer < ActiveModel::Serializer
  attributes :id, :user_id, :amount, :description, :transaction_date, :created_at, :updated_at

  belongs_to :category
  belongs_to :currency
end
