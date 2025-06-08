class Feedback < ApplicationRecord
  belongs_to :participant
  belongs_to :talk

  validates :rating, presence: true, inclusion: { in: 1..5, message: "must be between 1 and 5" }
  validates :comment, presence: true
  validates :participant_id, uniqueness: { scope: :talk_id, message: "has already submitted feedback for this talk" }

  validate :participant_attended_talk

  private

  def participant_attended_talk
    return unless participant_id && talk_id # Ensure IDs are present before querying

    unless Attendance.exists?(participant_id: participant_id, talk_id: talk_id)
      errors.add(:base, "Participant did not attend this talk, so cannot leave feedback.")
    end
  end
end
