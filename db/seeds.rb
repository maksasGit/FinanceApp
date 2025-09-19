puts "Seeding data..."

puts "Clearing currencies..."
Currency.destroy_all

puts "Creating currencies..."

currencies_data = [
  { code: 'USD', name: 'US Dollar', decimal_places: 2 },
  { code: 'PLN', name: 'Polish Zloty', decimal_places: 2 },
  { code: 'EUR', name: 'Euro', decimal_places: 2 },
  { code: 'BYN', name: 'Belarusian Ruble', decimal_places: 2 },
  { code: 'GBP', name: 'British Pound', decimal_places: 2 },
  { code: 'JPY', name: 'Japanese Yen', decimal_places: 0 },
  { code: 'AUD', name: 'Australian Dollar', decimal_places: 2 },
  { code: 'CAD', name: 'Canadian Dollar', decimal_places: 2 },
  { code: 'CHF', name: 'Swiss Franc', decimal_places: 2 }
]

currencies_data.each do |currency_hash|
  Currency.create!(
    code: currency_hash[:code],
    name: currency_hash[:name],
    decimal_places: currency_hash[:decimal_places]
  )
end

puts "Cleaning users..."

User.destroy_all

puts "Creating users..."

rich_user = User.create!(name: "Rich User", email: 'rich@example.com', password: "password", balance: 1_000_000)
poor_user = User.create!(name: "Poor User", email: 'poor@example.com', password: "password", balance: -1_000_000)

users_with_transactions = 2.times.map do |i|
  User.create!(name: "User With Transactions #{i + 1}", email: "transactor#{i}@example.com", password: "password", balance: 0)
end

users_without_transactions = 2.times.map do |i|
  User.create!(name: "User Without Transactions #{i + 1}", email: "no_transactor#{i}@example.com", password: "password", balance: 0)
end

puts "Clearing Categories..."
Category.destroy_all

puts "Creating default categories and subcategories..."

default_categories_data = [
  { name: "Salary", category_type: "income" },
  { name: "Investments", category_type: "income" },
  { name: "Food", category_type: "expense", children: [
      { name: "Fast Food", category_type: "expense", children: [
          { name: "KFC", category_type: "expense" }
        ]
      },
      { name: "Restaurants", category_type: "expense", children: [
          { name: "FALA", category_type: "expense" }
        ]
      }
    ]
  },
  { name: "Transport", category_type: "expense", children: [
      { name: "Public Transport", category_type: "expense" },
      { name: "Fuel", category_type: "expense" }
    ]
  },
  { name: "Entertainment", category_type: "expense" },
  # { name: "Ebay Refund", category_type: "refund" } # Uncomment after category_status refund merge
]

@default_categories = []

def create_category_with_children(category_hash, parent = nil)
  category = Category.create!(
    name: category_hash[:name],
    category_type: category_hash[:category_type],
    parent: parent
  )

  @default_categories << category

  if category_hash[:children]
    category_hash[:children].each do |child_hash|
      create_category_with_children(child_hash, category)
    end
  end
end

default_categories_data.each do |category_hash|
  create_category_with_children(category_hash)
end

puts "Clearing Transactions..."

Transaction.destroy_all

puts "Creating Transactions..."

def random_time(from, to)
  Time.at(rand(from.to_f..to.to_f))
end

TRANSACTION_AMOUNT = 50

currencies = Currency.all
categories = @default_categories
users = users_with_transactions

TRANSACTION_AMOUNT.times do
  amount = Faker::Commerce.price(range: 1..1000, as_string: false)
  user = users.sample
  category = categories.sample
  currency = currencies.sample
  description = Faker::Commerce.product_name
  time = random_time(1.week.ago, Time.current)

  Transaction.create!(
    amount: amount,
    user: user,
    category: category,
    currency: currency,
    description: description,
    transaction_date: time
  )
end

puts "Clearing Scheduled Transactions..."
ScheduledTransaction.destroy_all

puts "Creating Scheduled Transactions..."

SCHEDULED_TRANSACTION_AMOUNT = 20

frequencies = %w[once daily weekly monthly]

SCHEDULED_TRANSACTION_AMOUNT.times do
  user = users.sample
  category = categories.sample
  currency = currencies.sample
  start_time = random_time(Time.current - 1.week, Time.current + 1.week)

  frequency = frequencies.sample

  day_of_week = frequency == 'weekly' ? rand(0..6) : nil
  day_of_month = frequency == 'monthly' ? rand(1..28) : nil

  ScheduledTransaction.create!(
    user: user,
    category: category,
    currency: currency,
    start_date: start_time.to_date,
    frequency: frequency,
    day_of_week: day_of_week,
    day_of_month: day_of_month,
    amount: Faker::Commerce.price(range: 1..1000, as_string: false)
  )
end

puts "Seeding complete."