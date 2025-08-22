FactoryBot.define do
  factory :user do
    name { "John Doe" }
    email { "john@example.com" }
    password { "password123" }
  end

  factory :dynamic_user, class: User do
    sequence(:name) { |n| "User-#{n}" }
    sequence(:email) { |n| "user#{n}@example.com" }
    password { "password123" }
  end
end
