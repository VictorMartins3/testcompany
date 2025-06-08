require 'rails_helper'

RSpec.describe "Attendances", type: :request do
  describe "POST /attendances" do
    let(:event) { create(:event, start_date: 1.day.from_now, end_date: 3.days.from_now) }
    let(:talk) do
      create(:talk,
        event: event,
        start_time: event.start_date + 4.hours,
        end_time: event.start_date + 5.hours
      )
    end
    let(:participant) { create(:participant, event: event) }

    let(:valid_attributes) {
      {
        attendance: {
          participant_id: participant.id,
          talk_id: talk.id
        }
      }
    }

    let(:duplicate_attributes) { valid_attributes }

    let(:invalid_participant_attributes) {
      {
        attendance: {
          participant_id: 9999,
          talk_id: talk.id
        }
      }
    }

    let(:invalid_talk_attributes) {
      {
        attendance: {
          participant_id: participant.id,
          talk_id: 9999
        }
      }
    }

    context "with valid parameters" do
      it "returns http created status" do
        post "/attendances", params: valid_attributes
        expect(response).to have_http_status(:created)
      end

      it "creates a new attendance" do
        expect {
          post "/attendances", params: valid_attributes
        }.to change(Attendance, :count).by(1)
      end

      it "returns the created attendance" do
        post "/attendances", params: valid_attributes
        expect(JSON.parse(response.body)["participant_id"]).to eq(participant.id)
        expect(JSON.parse(response.body)["talk_id"]).to eq(talk.id)
      end
    end

    context "with duplicate attendance" do
      before { post "/attendances", params: valid_attributes }

      it "returns http unprocessable entity status" do
        post "/attendances", params: duplicate_attributes
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it "does not create a new attendance" do
        expect {
          post "/attendances", params: duplicate_attributes
        }.to change(Attendance, :count).by(0)
      end

      it "returns validation error for duplicate attendance" do
        post "/attendances", params: duplicate_attributes
        expect(JSON.parse(response.body)["errors"]).to have_key("participant_id")
      end
    end

    context "with non-existent participant ID" do
      it "returns http unprocessable entity status" do
        post "/attendances", params: invalid_participant_attributes
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it "does not create a new attendance" do
        expect {
          post "/attendances", params: invalid_participant_attributes
        }.to change(Attendance, :count).by(0)
      end
    end

    context "with non-existent talk ID" do
      it "returns http unprocessable entity status" do
        post "/attendances", params: invalid_talk_attributes
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it "does not create a new attendance" do
        expect {
          post "/attendances", params: invalid_talk_attributes
        }.to change(Attendance, :count).by(0)
      end
    end
  end
end
