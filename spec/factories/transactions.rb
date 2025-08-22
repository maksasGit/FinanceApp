FactoryBot.define do
    factory :transaction do
        association :user
        association :category
        association :currency
        amount { 100.0 }
        description { "Grocery shopping" }
        transaction_date { Time.zone.today }
    end

    factory :dynamic_transaction, class: 'Transaction' do
        association :user, factory: :dynamic_user
        association :category
        association :currency, factory: :dynamic_currency
        amount { Faker::Commerce.price(range: 1.0..1000.0) }
        description { Faker::Commerce.product_name }
    end
end
