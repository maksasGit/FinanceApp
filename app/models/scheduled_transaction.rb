class ScheduledTransaction < ApplicationRecord
    belongs_to :user
    belongs_to :category
    belongs_to :currency

    FREQUENCIES = %w[once daily weekly monthly].freeze

    validates :amount, presence: true, numericality: { greater_than: 0 }
    validates :frequency, presence: true, inclusion: { in: FREQUENCIES }
    validates :start_date, presence: true
    validates :next_execute_at, presence: true
    validates :active, inclusion: { in: [ true, false ] }

    validate :end_date_after_start_date
    validate :day_of_week_presence
    validate :day_of_month_presence

    before_validation :init_schedule

    private

    def init_schedule
        self.next_execute_at ||= start_date
        self.repeatable = (frequency != "once")
    end

    def end_date_after_start_date
        return if end_date.blank? || start_date.blank?
        errors.add(:end_date, "must be after start_date") if end_date < start_date
    end

    def day_of_week_presence
        if frequency == "weekly" && day_of_week.nil?
        errors.add(:day_of_week, "must be set if frequency is weekly")
        end
    end

    def day_of_month_presence
        if frequency == "monthly" && (day_of_month.nil? || (1..31).exclude?(day_of_month))
        errors.add(:day_of_month, "must be between 1 and 31 if frequency is monthly")
        end
    end
end
