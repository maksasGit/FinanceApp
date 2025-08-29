FactoryBot.define do
  factory :scheduled_transaction do
    association :user, factory: :dynamic_user
    association :category
    association :currency, factory: :dynamic_currency

    amount { Faker::Commerce.price(range: 10.0..1000.0) }
    description { Faker::Lorem.sentence(word_count: 3) }

    repeatable { false }
    frequency { "once" }
    start_date { 1.day.from_now.change(hour: 9, min: 0, sec: 0) }
    next_execute_at { start_date }
    active { true }

    end_date { nil }
    day_of_week { nil }
    day_of_month { nil }

    trait :daily do
      repeatable { true }
      frequency { "daily" }
    end

    trait :weekly do
      repeatable { true }
      frequency { "weekly" }
      day_of_week { 1 }
    end

    trait :monthly do
      repeatable { true }
      frequency { "monthly" }
      day_of_month { 1 }
    end

    trait :yearly do
      repeatable { true }
      frequency { "yearly" }
    end

    trait :ended do
      end_date { 1.day.ago }
      active { false }
    end
  end
end
