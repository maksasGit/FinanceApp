require 'rails_helper'

RSpec.describe ScheduledTransactionUpdateService do
  let(:scheduled_transaction) { create(:scheduled_transaction, :weekly) }

  describe "#call" do
    context "when updating with frequency 'once'" do
      let(:params) do
        {
          frequency: 'once',
          amount: 228,
          day_of_week: 3,
          day_of_month: 15
        }
      end

      it "clears day_of_week and day_of_month and updates attributes" do
        service = described_class.new(scheduled_transaction, params)
        updated = service.call

        expect(updated.day_of_week).to be_nil
        expect(updated.day_of_month).to be_nil
      end
    end

    context "when updating with frequency 'weekly'" do
      let(:params) do
        {
          frequency: 'weekly',
          day_of_week: 5,
          day_of_month: 12
        }
      end

      it "clears day_of_month and updates day_of_week" do
        service = described_class.new(scheduled_transaction, params)
        updated = service.call

        expect(updated.day_of_week).to eq(5)
        expect(updated.day_of_month).to be_nil
      end
    end

    context "when updating with frequency 'monthly'" do
      let(:params) do
        {
          frequency: 'monthly',
          day_of_month: 20,
          day_of_week: 1
        }
      end

      it "clears day_of_week and updates day_of_month" do
        service = described_class.new(scheduled_transaction, params)
        updated = service.call

        expect(updated.day_of_month).to eq(20)
        expect(updated.day_of_week).to be_nil
      end
    end

    context "when saving fails due to validation errors" do
      let(:invalid_params) do
        {
          frequency: "monthly",
          day_of_month: 50,
          day_of_week: nil
        }
      end

      it "raises ActiveRecord::RecordInvalid and does not update" do
        service = described_class.new(scheduled_transaction, invalid_params)

        expect {
          service.call
        }.to raise_error(ActiveRecord::RecordInvalid)
      end
    end
  end
end
