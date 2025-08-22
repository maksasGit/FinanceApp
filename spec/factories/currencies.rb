FactoryBot.define do
  factory :currency do
    code { "USD" }
    name { "US Dollar" }
    decimal_places { 2 }
  end

  factory :dynamic_currency, class: Currency do
    code { Faker::Currency.code }
    name { Faker::Currency.name }
    decimal_places { 2 }
  end
end
