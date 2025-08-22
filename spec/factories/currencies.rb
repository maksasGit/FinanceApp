FactoryBot.define do
  factory :currency do
    code { "USD" }
    name { "US Dollar" }
    decimal_places { 2 }
  end

  factory :dynamic_currency, class: Currency do
    sequence(:code) { |n| "CUR#{n}" }
    sequence(:name) { |n| "Currency #{n}" }
    decimal_places { 2 }
  end
end
