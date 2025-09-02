# Finance App (Ruby on Rails API)

## Overview
Finance App is a study project built with Ruby on Rails and MySQL, designed as an API to help users manage their expenses and incomes.  
Users can create categories and subcategories (linked to income or expense types), record transactions, and schedule recurring transactions like salary payments or subscription expenses.

---

## Features
- User authentication with JWT and BCrypt
- Create/manage categories and subcategories with income/expense types
- Record financial transactions linked to categories
- Schedule recurring transactions (e.g., monthly salary, subscriptions)
- Background jobs handled by Sidekiq with Redis and sidekiq-cron for scheduled jobs
- API-only backend for integration with any frontend or mobile app

---

## Technology Stack
- Ruby on Rails 8.0.2 (API-only mode)
- MySQL (Database)
- Redis (for Sidekiq background processing)
- Sidekiq and sidekiq-cron for background jobs and scheduling

---

## Installation

### Prerequisites
- Ruby (version compatible with Rails 8.0.2)
- Rails 8.0.2
- MySQL server
- Redis server (for Sidekiq)
- Bundler gem installed (`gem install bundler`)


## API Endpoints

### Authentication
| Method | Endpoint               | Description          |
|--------|------------------------|----------------------|
| POST   | `/api/v1/auth/login`   | User login and receive JWT token |

---

### Users
| Method | Endpoint                | Description           |
|--------|-------------------------|-----------------------|
| GET    | `/api/v1/users`         | List all users        |
| POST   | `/api/v1/users`         | Create a new user     |
| GET    | `/api/v1/users/:id`     | Get a user by ID      |
| PUT    | `/api/v1/users/:id`     | Update a user         |
| DELETE | `/api/v1/users/:id`     | Delete a user         |

---

### Currencies
| Method | Endpoint                   | Description            |
|--------|----------------------------|------------------------|
| GET    | `/api/v1/currencies`       | List all currencies    |
| POST   | `/api/v1/currencies`       | Create a currency      |
| GET    | `/api/v1/currencies/:id`   | Get a currency by ID   |
| PUT    | `/api/v1/currencies/:id`   | Update a currency      |
| DELETE | `/api/v1/currencies/:id`   | Delete a currency      |

---

### Categories
| Method | Endpoint               | Description           |
|--------|------------------------|-----------------------|
| GET    | `/api/v1/categories`   | List all categories   |
| POST   | `/api/v1/categories`   | Create a category     |
| GET    | `/api/v1/categories/:id` | Get category by ID   |
| PUT    | `/api/v1/categories/:id` | Update a category    |
| DELETE | `/api/v1/categories/:id` | Delete a category    |

---

### Transactions
| Method | Endpoint                 | Description            |
|--------|--------------------------|------------------------|
| GET    | `/api/v1/transactions`   | List all transactions   |
| POST   | `/api/v1/transactions`   | Create a transaction    |
| GET    | `/api/v1/transactions/:id` | Get transaction by ID |
| PUT    | `/api/v1/transactions/:id` | Update a transaction  |
| DELETE | `/api/v1/transactions/:id` | Delete a transaction  |

---

### Scheduled Transactions
| Method | Endpoint                          | Description               |
|--------|-----------------------------------|---------------------------|
| GET    | `/api/v1/scheduled_transactions` | List all scheduled transactions |
| POST   | `/api/v1/scheduled_transactions` | Create a scheduled transaction |
| GET    | `/api/v1/scheduled_transactions/:id` | Get scheduled transaction by ID |
| PUT    | `/api/v1/scheduled_transactions/:id` | Update a scheduled transaction |
| DELETE | `/api/v1/scheduled_transactions/:id` | Delete a scheduled transaction |

---