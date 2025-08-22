FactoryBot.define do
    factory :category do
        name { "Groceries" }
        category_type { "expense" }
    end

    factory :dynamic_category, class: Category do
        sequence(:name) { |n| "Category-#{n}" }
        category_type { [ "income", "expense" ].sample }
    end
end
