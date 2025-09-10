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
  validate :frequency_fields_consistency
  validate :day_of_week_value_range
  validate :day_of_month_value_range

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

  def frequency_fields_consistency
    case frequency
    when "monthly"
      errors.add(:frequency, "invalid scheduling fields for monthly") unless only_fields_present?(:day_of_month)
    when "weekly"
      errors.add(:frequency, "invalid scheduling fields for weekly") unless only_fields_present?(:day_of_week)
    when "once"
      errors.add(:frequency, "day_of_week and day_of_month must be nil for once frequency") unless only_fields_present?
    end
  end

  def only_fields_present?(*fields_present)
    attrs = { day_of_month: day_of_month, day_of_week: day_of_week }
    attrs.each do |field, value|
      if fields_present.include?(field)
        return false if value.nil?
      else
        return false unless value.nil?
      end
    end

    true
  end

  def day_of_week_value_range
    return if day_of_week.nil?
    unless day_of_week.is_a?(Integer) && (0..6).cover?(day_of_week)
      errors.add(:day_of_week, "must be an integer between 0 and 6")
    end
  end

  def day_of_month_value_range
    return if day_of_month.nil?
    unless day_of_month.is_a?(Integer) && (1..31).cover?(day_of_month)
      errors.add(:day_of_month, "must be an integer between 1 and 31")
    end
  end
end
