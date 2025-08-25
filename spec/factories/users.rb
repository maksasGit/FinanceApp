FactoryBot.define do
  factory :user do
    name { "John Doe" }
    email { "john@example.com" }
    password { "password123" }
  end

  factory :invalid_user, class: User do
    name { "" }
    email { nil }
    password { "c" }
  end

  factory :dynamic_user, class: User do
    name { Faker::Name.name }
    email { Faker::Internet.unique.email }
    password { Faker::Internet.password(min_length: 8) }
  end
end
