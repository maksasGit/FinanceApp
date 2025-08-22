require "test_helper"

class TransactionTest < ActiveSupport::TestCase
  setup do
    @user = User.create!(name: "John Doe", email: "example@email.com", password: "somepassword")
    @category = Category.create!(name: "Food")
    @currency = Currency.create!(code: "USD", name: "Dollar")
  end

  def build_transaction(attributes = {})
    Transaction.new({
      user: @user,
      category: @category,
      currency: @currency,
      amount: 100.0,
      description: "Grocery shopping"
    }.merge(attributes))
  end


  test "valid transaction" do
    transaction = build_transaction
    assert transaction.valid?
  end

  test "invalid transation - missing required parameters" do
    transaction = Transaction.create()
    assert_not transaction.valid?
  end

  test "invalid transaction - negative amount" do
    transaction = build_transaction(amount: -50)
    assert_not transaction.valid?
  end

  test "invalid transaction - description too long" do
    transaction = build_transaction(description: "a" * 300)
    assert_not transaction.valid?
  end

  test "transaction date is set to current date if not provided" do
    transaction = build_transaction
    transaction.save!
    assert_not_nil transaction.transaction_date
  end

  test "transaction deletion cascades to user" do
    transaction = build_transaction
    transaction.save!
    @user.destroy
    assert_nil Transaction.find_by(id: transaction.id)
  end
end
