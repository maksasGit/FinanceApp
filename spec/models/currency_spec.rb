require "rails_helper"

RSpec.describe Currency, type: :model do
  describe "validations" do
    it "valid currency" do
      currency = build(:currency)

      expect(currency).to be_valid
    end

    it "invalid currency - missing required parameters" do
      currency = build(:currency, code: "", name: "Euro")

      expect(currency).not_to be_valid
    end

    it "invalid currency - duplicate code" do
      create(:currency, code: "EUR")
      duplicate_currency = build(:currency, code: "EUR", name: "Euro Duplicate", decimal_places: 2)

      expect(duplicate_currency).not_to be_valid
    end
  end
end
