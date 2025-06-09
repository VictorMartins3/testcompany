require 'rails_helper'

RSpec.describe "Events", type: :request do
  describe "GET /events/:id" do
    context "when the event exists" do
      let(:event) { create(:event) }
      let!(:talks) { create_list(:talk, 3, event: event, start_time: event.start_date + 4.hours, end_time: event.start_date + 5.hours) }

      before { get "/events/#{event.id}" }

      it "returns http success" do
        expect(response).to have_http_status(:success)
      end

      it "returns the event with its talks" do
        json_response = JSON.parse(response.body)

        # Check event attributes
        expect(json_response["id"]).to eq(event.id)
        expect(json_response["title"]).to eq(event.title)
        expect(json_response["description"]).to eq(event.description)
        expect(json_response["location"]).to eq(event.location)

        # Check that talks are included
        expect(json_response["talks"].size).to eq(3)
        expect(json_response["talks"].map { |t| t["id"] }).to match_array(talks.map(&:id))
      end
    end

    context "when the event does not exist" do
      before { get "/events/999" }

      it "returns a not found status" do
        expect(response).to have_http_status(:not_found)
      end

      it "returns an error message" do
        json_response = JSON.parse(response.body)
        expect(json_response["error"]).to eq("Event not found")
      end
    end
  end

  describe "POST /events" do
    context "with valid parameters" do
      let(:valid_params) do
        {
          event: {
            title: "RailsConf 2025",
            description: "The biggest Rails conference of the year",
            location: "Chicago, USA",
            start_date: 1.month.from_now,
            end_date: 1.month.from_now + 3.days
          }
        }
      end

      it "creates a new event" do
        expect {
          post "/events", params: valid_params
        }.to change(Event, :count).by(1)
      end

      it "returns a created status" do
        post "/events", params: valid_params
        expect(response).to have_http_status(:created)
      end

      it "returns the created event as JSON" do
        post "/events", params: valid_params
        json_response = JSON.parse(response.body)

        expect(json_response["title"]).to eq(valid_params[:event][:title])
        expect(json_response["description"]).to eq(valid_params[:event][:description])
        expect(json_response["location"]).to eq(valid_params[:event][:location])
      end
    end

    context "with invalid parameters" do
      let(:invalid_params) do
        {
          event: {
            title: "",
            description: "Missing required fields",
            location: ""
          }
        }
      end

      it "does not create a new event" do
        expect {
          post "/events", params: invalid_params
        }.not_to change(Event, :count)
      end

      it "returns an unprocessable entity status" do
        post "/events", params: invalid_params
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it "returns validation errors" do
        post "/events", params: invalid_params
        json_response = JSON.parse(response.body)

        expect(json_response["errors"]).to be_present
        expect(json_response["errors"]["title"]).to include("can't be blank")
        expect(json_response["errors"]["location"]).to include("can't be blank")
        expect(json_response["errors"]["start_date"]).to include("can't be blank")
        expect(json_response["errors"]["end_date"]).to include("can't be blank")
      end
    end
  end

  describe "GET /events/:id/feedback_report" do
    let!(:event) { create(:event) }
    let!(:talk1) { create(:talk, event: event, title: "Talk 1 Title", start_time: event.start_date + 1.hour, end_time: event.start_date + 2.hours) }
    let!(:talk2) { create(:talk, event: event, title: "Talk 2 Title", start_time: event.start_date + 3.hours, end_time: event.start_date + 4.hours) }
    let!(:talk_no_feedback) { create(:talk, event: event, title: "Talk No Feedback", start_time: event.start_date + 5.hours, end_time: event.start_date + 6.hours) }

    let!(:participant1) { create(:participant, event: event) }
    let!(:participant2) { create(:participant, event: event) }

    before do
      # Attendances
      create(:attendance, participant: participant1, talk: talk1)
      create(:attendance, participant: participant2, talk: talk1)
      create(:attendance, participant: participant1, talk: talk2)

      # Feedbacks for Talk 1
      create(:feedback, talk: talk1, participant: participant1, rating: 5, comment: "Amazing talk!")
      create(:feedback, talk: talk1, participant: participant2, rating: 4, comment: "Very good.")

      # Feedback for Talk 2
      create(:feedback, talk: talk2, participant: participant1, rating: 3, comment: "Okay.")

      get "/events/#{event.id}/feedback_report"
    end

    it "returns http success" do
      expect(response).to have_http_status(:success)
    end

    it "returns the feedback report as JSON" do
      json_response = JSON.parse(response.body)

      expect(json_response["event_id"]).to eq(event.id)
      expect(json_response["event_title"]).to eq(event.title)

      talk_feedbacks = json_response["talk_feedbacks"]
      expect(talk_feedbacks.size).to eq(3) # talk1, talk2, talk_no_feedback

      talk1_report = talk_feedbacks.find { |t| t["talk_id"] == talk1.id }
      expect(talk1_report["talk_title"]).to eq("Talk 1 Title")
      expect(talk1_report["average_rating"]).to eq(4.5)
      expect(talk1_report["feedback_count"]).to eq(2)
      expect(talk1_report["comments"]).to match_array([ "Amazing talk!", "Very good." ])

      talk2_report = talk_feedbacks.find { |t| t["talk_id"] == talk2.id }
      expect(talk2_report["talk_title"]).to eq("Talk 2 Title")
      expect(talk2_report["average_rating"]).to eq(3.0)
      expect(talk2_report["feedback_count"]).to eq(1)
      expect(talk2_report["comments"]).to match_array([ "Okay." ])

      talk_no_feedback_report = talk_feedbacks.find { |t| t["talk_id"] == talk_no_feedback.id }
      expect(talk_no_feedback_report["talk_title"]).to eq("Talk No Feedback")
      expect(talk_no_feedback_report["average_rating"]).to be_nil
      expect(talk_no_feedback_report["feedback_count"]).to eq(0)
      expect(talk_no_feedback_report["comments"]).to be_empty
    end

    context "when the event does not exist" do
      it "returns a not found status" do
        get "/events/9999/feedback_report"
        expect(response).to have_http_status(:not_found)
      end
    end
  end
end
