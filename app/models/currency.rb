class Currency < ApplicationRecord
    has_many :transactions

    validates :code, presence: true, uniqueness: true
    validates :name, presence: true
    validates :decimal_places, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

    before_save :set_default_decimal_places

    private
    def set_default_decimal_places
        self.decimal_places ||= 2
    end
end
