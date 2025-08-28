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

        expect(scheduled_transaction.errors[:end_date]).to include("must be after start_date")
      end
    end

    describe "day_of_week_presence_if_weekly" do
      it "is invalid if frequency is weekly but day_of_week is not present" do
        scheduled_transaction = build(:scheduled_transaction, frequency: 'weekly', day_of_week: nil)

        expect(scheduled_transaction).not_to be_valid
        expect(scheduled_transaction.errors[:day_of_week]).to include("must be set if frequency is weekly")
      end

      it "is valid if frequency is weekly and day_of_week is present" do
        scheduled_transaction = build(:scheduled_transaction, frequency: 'weekly', day_of_week: 3)

        expect(scheduled_transaction).to be_valid
      end

      it "is valid if frequency is not weekly and day_of_week is nil" do
        scheduled_transaction = build(:scheduled_transaction, frequency: 'monthly', day_of_month: 23, day_of_week: nil)

        expect(scheduled_transaction).to be_valid
      end
    end

    describe "day_of_month_presence_if_monthly" do
      it "is invalid if frequency is monthly but day_of_month is nil" do
        scheduled_transaction = build(:scheduled_transaction, frequency: 'monthly', day_of_month: nil)

        expect(scheduled_transaction).not_to be_valid
        expect(scheduled_transaction.errors[:day_of_month]).to include("must be between 1 and 31 if frequency is monthly")
      end

      it "is invalid if day_of_month is out of range" do
        scheduled_transaction = build(:scheduled_transaction, frequency: 'monthly', day_of_month: 50)

        expect(scheduled_transaction).not_to be_valid
      end

      it "is valid if frequency is monthly and day_of_month in 1..31" do
        scheduled_transaction = build(:scheduled_transaction, frequency: 'monthly', day_of_month: 23)

        expect(scheduled_transaction).to be_valid
      end

      it "is valid if frequency is not monthly and day_of_month is nil" do
        scheduled_transaction = build(:scheduled_transaction, frequency: 'weekly', day_of_week: 3, day_of_month: nil)

        expect(scheduled_transaction).to be_valid
      end
    end
  end
end
