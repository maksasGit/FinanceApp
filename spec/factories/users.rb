FactoryBot.define do
  factory :user do
    name { "John Doe" }
    email { "john@example.com" }
    password { "password123" }
    password_confirmation { "password123" }
  end

  factory :auth_user, class: User do
    name { "Super User" }
    email { "not_repeatable_super_email_example_228@example.com" }
    password { "password123" }
    password_confirmation { "password123" }
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
    password_confirmation { password }
  end
end
