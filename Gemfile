source "https://rubygems.org"

# --- Core Framework ---
gem "rails", "~> 8.0.2", ">= 8.0.2.1"
gem "mysql2", "~> 0.5", ">= 0.5.6"
gem "puma", ">= 6.6.1"
gem "bootsnap", "1.18.6", require: false

# --- Authentication ---
gem "bcrypt", "3.1.20"
gem "jwt", "3.1.2"

# --- APIs / Serialization ---
gem "jsonapi-serializer", "2.2.0"
gem "rack-cors", "3.0.0"

# --- Background Jobs  ---
gem "sidekiq-cron", "2.3.1"

group :development, :test do
  # Debugging
  gem "debug", "1.11.0", platforms: %i[mri windows], require: "debug/prelude"

  # Security Analysis
  gem "brakeman", "7.1.0", require: false

  # Code Quality and Style
  gem "rubocop", "1.80.2", require: false
  gem "rubocop-rails", "2.33.3", require: false
  gem "rubocop-performance", "1.25.0", require: false
  gem "rubocop-rspec", "3.7.0", require: false
  gem "rubocop-rails-omakase", "1.1.0", require: false

  # Testing
  gem "rspec-rails", "8.0.2"
  gem "factory_bot_rails", "6.5.1"
  gem "faker", "3.5.2"
end
