class Category < ApplicationRecord
    belongs_to :user, optional: true
    belongs_to :parent, class_name: "Category", optional: true, inverse_of: :children

    has_many :children, class_name: "Category", foreign_key: "parent_id", dependent: :destroy, inverse_of: :parent
    has_many :transactions, dependent: :nullify
    has_many :scheduled_transactions, dependent: :nullify

    validates :name, presence: true
    validates :category_type, presence: true, inclusion: { in: [ "income", "expense" ] }

    validate :parent_must_exist
    validate :user_must_exist
    validate :parent_belongs_to_user_or_default
    validate :parent_category_type_match

    before_validation :set_default_category_type

    private

    def parent_must_exist
        if parent_id.present? && parent.nil?
            errors.add(:parent_id, "must refer to an existing category")
        end
    end

    def user_must_exist
        if user_id.present? && user.nil?
            errors.add(:user_id, "must refer to an existing user")
        end
    end

    def set_default_category_type
        self.category_type = "expense" if category_type.blank?
    end

    def parent_belongs_to_user_or_default
        if parent.present? && parent.user_id.present? && parent.user_id != user_id
            errors.add(:parent_id, "must belong to current user or be a default category")
        end
    end

    def parent_category_type_match
        if parent.present? && parent.category_type != category_type
            errors.add(:category_type, "must match parent category type")
        end
    end
end
