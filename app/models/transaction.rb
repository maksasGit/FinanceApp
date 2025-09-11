class Transaction < ApplicationRecord
  belongs_to :user
  belongs_to :category
  belongs_to :currency

  validates :amount, presence: true, numericality: { greater_than: 0 }
  validates :transaction_date, presence: true
  validates :description, length: { maximum: 255 }

  before_validation :set_date_if_not_set

  public

  def amount_adjustment
    multiplier = category&.expense? ? -1 : 1
    amount * multiplier
  end

  private

  def set_date_if_not_set
    self.transaction_date ||= DateTime.current
  end
end
