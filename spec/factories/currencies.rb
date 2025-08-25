FactoryBot.define do
  factory :currency do
    code { "USD" }
    name { "US Dollar" }
    decimal_places { 2 }
  end

  factory :invalid_currency, class: Currency do
    code { nil }
    name { "" }
    decimal_places { 200000 }
  end

  factory :dynamic_currency, class: Currency do
    code { Faker::Currency.code }
    name { Faker::Currency.name }
    decimal_places { 2 }
  end
end
