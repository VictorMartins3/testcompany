require 'rails_helper'

RSpec.describe Talk, type: :model do
  let(:event) { create(:event, start_date: Time.current, end_date: Time.current + 2.days) }

  describe "associations" do
    it { should belong_to(:event) }
    it { should have_many(:attendances).dependent(:destroy) }
    it { should have_many(:participants).through(:attendances) }
    it { should have_many(:feedbacks).dependent(:destroy) }
  end

  describe "validations" do
    subject { build(:talk, event: event, start_time: event.start_date + 1.hour, end_time: event.start_date + 2.hours) }

    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:description) }
    it { should validate_presence_of(:speaker) }
    it { should validate_presence_of(:start_time) }
    it { should validate_presence_of(:end_time) }

    context "custom validations" do
      it "is invalid if end_time is before start_time" do
        talk = build(:talk, event: event, start_time: event.start_date + 2.hours, end_time: event.start_date + 1.hour)
        expect(talk).not_to be_valid
        expect(talk.errors[:end_time]).to include("must be after the start time")
      end

      it "is valid if end_time is after start_time" do
        talk = build(:talk, event: event, start_time: event.start_date + 1.hour, end_time: event.start_date + 2.hours)
        expect(talk).to be_valid
      end

      it "is invalid if start_time is before event start_date" do
        talk = build(:talk, event: event, start_time: event.start_date - 1.hour, end_time: event.start_date + 1.hour)
        expect(talk).not_to be_valid
        expect(talk.errors[:start_time]).to include("cannot be before the event start date")
      end

      it "is invalid if end_time is after event end_date" do
        talk = build(:talk, event: event, start_time: event.end_date - 1.hour, end_time: event.end_date + 1.hour)
        expect(talk).not_to be_valid
        expect(talk.errors[:end_time]).to include("cannot be after the event end date")
      end

      it "is valid if talk times are within event dates" do
        talk = build(:talk, event: event, start_time: event.start_date + 1.hour, end_time: event.end_date - 1.hour)
        expect(talk).to be_valid
      end
    end
  end
end
