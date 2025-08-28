class User < ApplicationRecord
    has_secure_password

    has_many :categories, dependent: :destroy
    has_many :transactions, dependent: :destroy
    has_many :scheduled_transactions, dependent: :destroy

    validates :email, presence: true, uniqueness: true
    validates :name, presence: true
end
