FactoryBot.define do
    factory :category do
        name { "Groceries" }
        category_type { "expense" }
    end

    factory :dynamic_category, class: Category do
        name { Faker::Commerce.product_name }
        category_type { [ "income", "expense" ].sample }
    end
end
