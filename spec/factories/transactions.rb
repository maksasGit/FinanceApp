FactoryBot.define do
    factory :transaction do
        association :user
        association :category
        association :currency
        amount { 100.0 }
        description { "Grocery shopping" }
        transaction_date { Date.today }
    end

    factory :dynamic_transaction, class: 'Transaction' do
        association :user, factory: :dynamic_user
        association :category
        association :currency, factory: :dynamic_currency
        amount { rand(10.0..500.0) }
        sequence(:description) { |n| "Transaction #{n}" }
    end
end
