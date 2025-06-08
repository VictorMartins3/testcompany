require 'rails_helper'

RSpec.describe Participant, type: :model do
  describe 'associations' do
    it 'belongs to an event' do
      association = described_class.reflect_on_association(:event)
      expect(association.macro).to eq :belongs_to
    end
  end

  describe 'validations' do
    it 'validates presence of name' do
      participant = build(:participant, name: nil)
      participant.valid?
      expect(participant.errors[:name]).to include("can't be blank")
    end

    it 'validates presence of email' do
      participant = build(:participant, email: nil)
      participant.valid?
      expect(participant.errors[:email]).to include("can't be blank")
    end

    it 'validates presence of event_id' do
      participant = build(:participant, event_id: nil)
      participant.valid?
      expect(participant.errors[:event_id]).to include("can't be blank")
    end
  end
end
