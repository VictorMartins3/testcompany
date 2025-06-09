require 'rails_helper'

RSpec.describe "Feedbacks API", type: :request do
  let!(:event) { create(:event) }
  let!(:talk) { create(:talk, event: event, start_time: event.start_date + 1.hour, end_time: event.start_date + 2.hours) }
  let!(:participant) { create(:participant, event: event) }

  describe "POST /talks/:talk_id/feedbacks" do
    let(:valid_attributes) { { feedback: { participant_id: participant.id, rating: 5, comment: "Excellent talk!" } } }
    let(:invalid_rating_attributes) { { feedback: { participant_id: participant.id, rating: 6, comment: "Rating too high" } } }
    let(:missing_comment_attributes) { { feedback: { participant_id: participant.id, rating: 3 } } }

    context "when participant attended the talk" do
      before do
        create(:attendance, participant: participant, talk: talk)
      end

      context "with valid parameters" do
        it "creates a new Feedback" do
          expect {
            post "/talks/#{talk.id}/feedbacks", params: valid_attributes
          }.to change(Feedback, :count).by(1)
        end

        it "returns a created status" do
          post "/talks/#{talk.id}/feedbacks", params: valid_attributes
          expect(response).to have_http_status(:created)
        end

        it "returns the created feedback as JSON" do
          post "/talks/#{talk.id}/feedbacks", params: valid_attributes
          json_response = JSON.parse(response.body)
          expect(json_response["rating"]).to eq(5)
          expect(json_response["comment"]).to eq("Excellent talk!")
          expect(json_response["participant_id"]).to eq(participant.id)
          expect(json_response["talk_id"]).to eq(talk.id)
        end
      end

      context "with invalid parameters (e.g., rating out of range)" do
        it "does not create a new Feedback" do
          expect {
            post "/talks/#{talk.id}/feedbacks", params: invalid_rating_attributes
          }.not_to change(Feedback, :count)
        end

        it "returns an unprocessable entity status" do
          post "/talks/#{talk.id}/feedbacks", params: invalid_rating_attributes
          expect(response).to have_http_status(:unprocessable_entity)
        end

        it "returns validation errors" do
          post "/talks/#{talk.id}/feedbacks", params: invalid_rating_attributes
          json_response = JSON.parse(response.body)
          expect(json_response["errors"]).to include("Rating must be between 1 and 5")
        end
      end

      context "when participant tries to submit feedback twice for the same talk" do
        before do
          create(:feedback, participant: participant, talk: talk, rating: 4, comment: "First comment")
        end

        it "does not create a new Feedback" do
          expect {
            post "/talks/#{talk.id}/feedbacks", params: valid_attributes
          }.not_to change(Feedback, :count)
        end

        it "returns an unprocessable entity status" do
          post "/talks/#{talk.id}/feedbacks", params: valid_attributes
          expect(response).to have_http_status(:unprocessable_entity)
          json_response = JSON.parse(response.body)
          expect(json_response["errors"]).to include("Participant has already submitted feedback for this talk")
        end
      end
    end

    context "when participant did not attend the talk" do
      it "does not create a new Feedback" do
        expect {
          post "/talks/#{talk.id}/feedbacks", params: valid_attributes
        }.not_to change(Feedback, :count)
        expect(response).to have_http_status(:unprocessable_entity)
        json_response = JSON.parse(response.body)
        expect(json_response["errors"]).to include("Participant did not attend this talk, so cannot leave feedback.")
      end
    end
  end
end
