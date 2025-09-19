FactoryBot.define do
  factory :category do
    name { "Groceries" }
    category_type { :expense }
  end

  factory :invalid_category, class: Category  do
    name { nil }
    category_type { nil }
  end

  factory :dynamic_category, class: Category do
    association :user, factory: :dynamic_user
    name { Faker::Commerce.product_name }
    category_type { Category.category_types.keys.sample }

    parent { nil }

    trait :with_parent do
      association :parent, factory: :dynamic_category
    end
  end
end
