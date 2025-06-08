class Participant < ApplicationRecord
  belongs_to :event
  has_many :attendances, dependent: :destroy
  has_many :talks, through: :attendances

  validates :name, :email, :event_id, presence: true
end
