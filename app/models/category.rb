class Category < ApplicationRecord
    belongs_to :user, optional: true
    belongs_to :parent, class_name: "Category", optional: true, inverse_of: :children

    has_many :children, class_name: "Category", foreign_key: "parent_id", dependent: :destroy, inverse_of: :parent
    has_many :transactions, dependent: :nullify

    validates :name, presence: true
    validates :category_type, presence: true, inclusion: { in: [ "income", "expense" ] }

    validate :parent_must_exist
    validate :user_must_exist

    before_validation :set_default_category_type

    private

    def parent_must_exist
        if parent_id.present? && !Category.exists?(parent_id)
            errors.add(:parent_id, "must refer to an existing category")
        end
    end

    def user_must_exist
        if user_id.present? && !User.exists?(user_id)
            errors.add(:user_id, "must refer to an existing user")
        end
    end

    def set_default_category_type
        self.category_type = "expense" if category_type.blank?
    end
end
