FactoryBot.define do
    factory :transaction do
        association :user
        association :category
        association :currency
        amount { 100.0 }
        description { "Grocery shopping" }
        transaction_date { DateTime.current }
    end

    factory :transaction_with_associations, class: Transaction do
        amount { 100.0 }
        description { "Grocery shopping" }
        transaction_date { DateTime.current }
        after(:build) do |transaction|
            transaction.user ||= create(:user)
            transaction.category ||= create(:category)
            transaction.currency ||= create(:currency)
        end
    end

    factory :invalid_transaction, class: Transaction do
        user_id { 0 }
        amount { -100 }
        description { nil }
        transaction_date { nil }
    end

    factory :dynamic_transaction, class: Transaction do
        association :user, factory: :dynamic_user
        association :category
        association :currency, factory: :dynamic_currency
        amount { Faker::Commerce.price(range: 1.0..1000.0) }
        description { Faker::Commerce.product_name }
    end
end
