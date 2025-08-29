require 'rails_helper'
require 'sidekiq/testing'

Sidekiq::Testing.inline!

RSpec.describe ScheduledTransactionJob, type: :job do
  let(:current_user) { create(:auth_user) }

  before do
    create_list(:scheduled_transaction, 3, next_execute_at: 1.minute.ago, active: true, user: current_user)
    create_list(:scheduled_transaction, 2, next_execute_at: 1.day.from_now, active: true, user: current_user)
    create_list(:scheduled_transaction, 2, next_execute_at: 1.minute.ago, active: false, user: current_user)
  end

  it 'processes only scheduled transactions that are active and due' do
    expect {
      described_class.perform_async
    }.to change(Transaction, :count).by(3)
  end

  it 'updates next_execute_at appropriately' do
    scheduled_transaction = create(:scheduled_transaction, :daily, next_execute_at: 1.minute.ago)
    old_execute_date = scheduled_transaction.next_execute_at
    described_class.perform_async
    scheduled_transaction.reload

    expect(scheduled_transaction.next_execute_at).to eq(old_execute_date + 1.day)
  end

  it 'updates active appropriately' do
    scheduled_transaction = create(:scheduled_transaction, next_execute_at: 1.minute.ago, active: true)
    described_class.perform_async
    scheduled_transaction.reload

    expect(scheduled_transaction.active).to be(false)
  end
end
