require 'rails_helper'

RSpec.describe Attendance, type: :model do
  describe 'associations' do
    it 'belongs to a participant' do
      association = described_class.reflect_on_association(:participant)
      expect(association.macro).to eq :belongs_to
    end

    it 'belongs to a talk' do
      association = described_class.reflect_on_association(:talk)
      expect(association.macro).to eq :belongs_to
    end
  end

  describe 'validations' do
    # Create a consistent event and timing setup
    let(:event) do
      create(:event,
        start_date: 1.day.from_now,
        end_date: 3.days.from_now)
    end

    let(:talk) do
      create(:talk,
        event: event,
        start_time: event.start_date + 4.hours,
        end_time: event.start_date + 5.hours)
    end

    let(:participant) { create(:participant, event: event) }

    it 'is valid with valid attributes' do
      attendance = build(:attendance, talk: talk, participant: participant)
      expect(attendance).to be_valid
    end

    it 'validates presence of participant_id' do
      attendance = build(:attendance, talk: talk, participant: nil)
      attendance.valid?
      expect(attendance.errors[:participant_id]).to include("can't be blank")
    end

    it 'validates presence of talk_id' do
      attendance = build(:attendance, talk: nil, participant: participant)
      attendance.valid?
      expect(attendance.errors[:talk_id]).to include("can't be blank")
    end

    it 'prevents duplicate attendance for the same participant and talk' do
      # Create an initial attendance
      first_attendance = create(:attendance, talk: talk, participant: participant)

      # Try to create a duplicate attendance
      duplicate_attendance = build(:attendance,
                                 participant: first_attendance.participant,
                                 talk: first_attendance.talk)

      duplicate_attendance.valid?
      expect(duplicate_attendance.errors[:participant_id]).to include("has already attended this talk")
    end
  end
end
