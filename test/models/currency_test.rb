require "test_helper"

class CurrencyTest < ActiveSupport::TestCase
  test "valid currency" do
    currency = Currency.new(code: "USD", name: "US Dollar", decimal_places: 2)
    assert currency.valid?
  end

  test "invalid currency - missing required parameters" do
    currency = Currency.new(code: "", name: "Euro")
    assert_not currency.valid?
  end

  test "invalid currency - duplicate code" do
    Currency.create(code: "EUR", name: "Euro", decimal_places: 2)
    duplicate_currency = Currency.new(code: "EUR", name: "Euro Duplicate", decimal_places: 2)
    assert_not duplicate_currency.valid?
  end
end
