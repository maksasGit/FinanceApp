FactoryBot.define do
    factory :transaction do
        association :user
        association :category
        association :currency
        amount { 100.0 }
        description { "Grocery shopping" }
        transaction_date { Date.today }
    end
end
