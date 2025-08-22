FactoryBot.define do
  factory :currency do
    code { "USD" }
    name { "US Dollar" }
    decimal_places { 2 }
  end
end
