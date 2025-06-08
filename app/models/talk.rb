class Talk < ApplicationRecord
  belongs_to :event
  has_many :attendances, dependent: :destroy
  has_many :participants, through: :attendances
  has_many :feedbacks, dependent: :destroy

  validates :title, :description, :speaker, :start_time, :end_time, presence: true
  validate :end_time_after_start_time
  validate :talk_within_event_dates

  private

  def end_time_after_start_time
    return if end_time.blank? || start_time.blank?

    if end_time <= start_time
      errors.add(:end_time, "must be after the start time")
    end
  end

  def talk_within_event_dates
    return if event.nil? || start_time.blank? || end_time.blank?

    if start_time < event.start_date
      errors.add(:start_time, "cannot be before the event start date")
    end

    if end_time > event.end_date
      errors.add(:end_time, "cannot be after the event end date")
    end
  end
end
