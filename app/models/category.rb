class Category < ApplicationRecord
    belongs_to :user, optional: true
    belongs_to :parent, class_name: "Category", optional: true

    has_many :children, class_name: "Category", foreign_key: "parent_id", dependent: :destroy

    validates :name, presence: true
    validates :category_type, presence: true, inclusion: { in: [ "income", "expense" ] }

    before_validation :set_default_category_type

    private

    def set_default_category_type
        self.category_type = "expense" if category_type.blank?
    end
end
