require 'rails_helper'

RSpec.describe Feedback, type: :model do
  let(:event) { create(:event) }
  let(:talk) { create(:talk, event: event, start_time: event.start_date + 1.hour, end_time: event.start_date + 2.hours) }
  let(:participant) { create(:participant, event: event) }

  describe "associations" do
    it { should belong_to(:participant) }
    it { should belong_to(:talk) }
  end

  describe "validations" do
    subject { build(:feedback, participant: participant, talk: talk) }

    before do
      create(:attendance, participant: participant, talk: talk)
    end

    it { should validate_presence_of(:rating) }
    it { should validate_inclusion_of(:rating).in_range(1..5).with_message("must be between 1 and 5") }
    it { should validate_presence_of(:comment) }

    it "validates uniqueness of participant_id scoped to talk_id" do
      create(:feedback, participant: participant, talk: talk, rating: 5, comment: "Great!")
      new_feedback = build(:feedback, participant: participant, talk: talk, rating: 4, comment: "Another comment")
      expect(new_feedback).not_to be_valid
      expect(new_feedback.errors[:participant_id]).to include("has already submitted feedback for this talk")
    end

    describe "#participant_attended_talk" do
      let(:unattended_talk) { create(:talk, event: event, start_time: event.start_date + 3.hours, end_time: event.start_date + 4.hours) }

      it "is valid if participant attended the talk" do
        feedback = build(:feedback, participant: participant, talk: talk)
        expect(feedback).to be_valid
      end

      it "is invalid if participant did not attend the talk" do
        feedback_for_unattended_talk = build(:feedback, participant: participant, talk: unattended_talk)
        expect(feedback_for_unattended_talk).not_to be_valid
        expect(feedback_for_unattended_talk.errors[:base]).to include("Participant did not attend this talk, so cannot leave feedback.")
      end
    end
  end
end
