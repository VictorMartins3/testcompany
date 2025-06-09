require 'rails_helper'

RSpec.describe Event, type: :model do
  describe "associations" do
    it { should have_many(:talks).dependent(:destroy) }
  end

  describe "validations" do
    subject { build(:event) }

    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:start_date) }
    it { should validate_presence_of(:end_date) }

    it "is invalid if end_date is before start_date" do
      event = build(:event, start_date: Time.current, end_date: 1.day.ago)
      expect(event).not_to be_valid
      expect(event.errors[:end_date]).to include("must be after the start date")
    end
  end
end
