class User < ApplicationRecord
    has_many :categories, dependent: :destroy
    has_many :transactions, dependent: :destroy

    validates :email, presence: true, uniqueness: true
    validates :name, presence: true
    validates :password, presence: true, length: { minimum: 6 }
end
