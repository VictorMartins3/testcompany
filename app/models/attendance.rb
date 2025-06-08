class Attendance < ApplicationRecord
  belongs_to :participant
  belongs_to :talk

  validates :participant_id, :talk_id, presence: true
  validates :participant_id, uniqueness: { scope: :talk_id, message: "has already attended this talk" }
end
