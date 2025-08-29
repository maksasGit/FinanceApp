require 'rails_helper'

RSpec.describe ScheduledTransaction, type: :model do
  describe "validations" do
    it "is valid with valid attributes" do
      scheduled_transaction = build(:scheduled_transaction)

      expect(scheduled_transaction).to be_valid
    end

    it "is invalid without required fields" do
      scheduled_transaction = build(:scheduled_transaction, amount: nil, frequency: nil, start_date: nil, next_execute_at: nil)

      expect(scheduled_transaction).not_to be_valid
    end

    it "validates amount greater than zero" do
      scheduled_transaction = build(:scheduled_transaction, amount: -10)

      expect(scheduled_transaction).not_to be_valid
      expect(scheduled_transaction.errors[:amount]).to include("must be greater than 0")
    end

    it "validates frequency inclusion" do
      scheduled_transaction = build(:scheduled_transaction, frequency: "invalid_frequency")

      expect(scheduled_transaction).not_to be_valid
      expect(scheduled_transaction.errors[:frequency]).to include("is not included in the list")
    end

    it "validates presence of user, category, and currency" do
      scheduled_transaction = build(:scheduled_transaction, user_id: nil, category_id: nil, currency_id: nil)

      expect(scheduled_transaction).not_to be_valid
    end
  end

  describe "associations" do
    it "deletes scheduled_transactions when user is destroyed" do
      scheduled_transaction = create(:scheduled_transaction)
      user = scheduled_transaction.user
      user.destroy

      expect(described_class).not_to exist(scheduled_transaction.id)
    end
  end

  describe "callbacks" do
    describe "before_validation" do
      it "sets next_execute_at to start_date if blank" do
        scheduled_transaction = build(:scheduled_transaction, next_execute_at: nil)
        scheduled_transaction.valid?

        expect(scheduled_transaction.next_execute_at.to_date).to eq(scheduled_transaction.start_date.to_date)
      end

      it "sets repeatable false if frequency is 'once'" do
        scheduled_transaction = build(:scheduled_transaction, frequency: "once")
        scheduled_transaction.valid?

        expect(scheduled_transaction.repeatable).to be false
      end

      it "sets repeatable true if frequency is not 'once'" do
        scheduled_transaction = build(:scheduled_transaction, frequency: "weekly", day_of_week: 0)
        scheduled_transaction.valid?

        expect(scheduled_transaction.repeatable).to be true
      end
    end
  end

  describe "custom validations" do
    describe "end_date_after_start_date" do
      it "allows blank end_date" do
        scheduled_transaction = build(:scheduled_transaction, start_date: 1.day.from_now, end_date: nil)

        expect(scheduled_transaction).to be_valid
      end

      it "is invalid if end_date < start_date" do
        scheduled_transaction = build(:scheduled_transaction, start_date: 2.days.from_now, end_date: 1.day.from_now)

        expect(scheduled_transaction).not_to be_valid
      end
    end

    describe "#frequency_fields_consistency" do
      it "is valid if both day_of_week and day_of_month are nil when frequency is once" do
        scheduled_transaction = build(:scheduled_transaction, frequency: 'once', day_of_week: nil, day_of_month: nil)

        expect(scheduled_transaction).to be_valid
      end

      it "is invalid if day_of_week is set with frequency once" do
        scheduled_transaction = build(:scheduled_transaction, frequency: 'once', day_of_week: 2)

        expect(scheduled_transaction).not_to be_valid
      end

        it "is invalid if day_of_month is set with frequency once" do
        scheduled_transaction = build(:scheduled_transaction, frequency: 'once', day_of_month: 23)

        expect(scheduled_transaction).not_to be_valid
      end

      it "is valid if only day_of_week is set when frequency is weekly" do
        scheduled_transaction = build(:scheduled_transaction, frequency: 'weekly', day_of_week: 3, day_of_month: nil)

        expect(scheduled_transaction).to be_valid
      end

      it "is invalid if day_of_month is set when frequency is weekly" do
        scheduled_transaction = build(:scheduled_transaction, frequency: 'weekly', day_of_week: 1, day_of_month: 5)

        expect(scheduled_transaction).not_to be_valid
      end

      it "is invalid if day_of_week is nil when frequency is weekly" do
        scheduled_transaction = build(:scheduled_transaction, frequency: 'weekly', day_of_week: nil, day_of_month: nil)

        expect(scheduled_transaction).not_to be_valid
      end

      it "is valid if only day_of_month is set when frequency is monthly" do
        scheduled_transaction = build(:scheduled_transaction, frequency: 'monthly', day_of_month: 23, day_of_week: nil)

        expect(scheduled_transaction).to be_valid
      end

      it "is invalid if day_of_week is set when frequency is monthly" do
        scheduled_transaction = build(:scheduled_transaction, frequency: 'monthly', day_of_month: 10, day_of_week: 2)

        expect(scheduled_transaction).not_to be_valid
      end

      it "is invalid if day_of_month is nil when frequency is monthly" do
        scheduled_transaction = build(:scheduled_transaction, frequency: 'monthly', day_of_month: nil, day_of_week: nil)

        expect(scheduled_transaction).not_to be_valid
      end
    end

    describe "#day_of_week_value_range" do
      it "is valid if day_of_week is nil" do
        scheduled_transaction = build(:scheduled_transaction, day_of_week: nil)

        expect(scheduled_transaction).to be_valid
      end

      it "is invalid if day_of_week is less than 0" do
        scheduled_transaction = build(:scheduled_transaction, day_of_week: -1)

        expect(scheduled_transaction).not_to be_valid
      end

      it "is invalid if day_of_week is greater than 6" do
        scheduled_transaction = build(:scheduled_transaction, day_of_week: 7)

        expect(scheduled_transaction).not_to be_valid
      end

      it "is invalid if day_of_week is not an integer" do
        scheduled_transaction = build(:scheduled_transaction, day_of_week: "Monday")

        expect(scheduled_transaction).not_to be_valid
      end
    end

    describe "#day_of_month_value_range" do
      it "is valid if day_of_month is nil" do
        scheduled_transaction = build(:scheduled_transaction, day_of_month: nil)

        expect(scheduled_transaction).to be_valid
      end

      it "is invalid if day_of_month is less than 1" do
        scheduled_transaction = build(:scheduled_transaction, day_of_month: 0)

        expect(scheduled_transaction).not_to be_valid
      end

      it "is invalid if day_of_month is greater than 31" do
        scheduled_transaction = build(:scheduled_transaction, day_of_month: 32)

        expect(scheduled_transaction).not_to be_valid
      end

      it "is invalid if day_of_month is not an integer" do
        scheduled_transaction = build(:scheduled_transaction, day_of_month: "15th")

        expect(scheduled_transaction).not_to be_valid
      end
    end
  end
end
