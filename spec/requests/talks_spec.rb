require 'rails_helper'

RSpec.describe "Talks", type: :request do
  describe "POST /talks" do
    let(:event) { create(:event) }

    context "with valid parameters" do
      let(:valid_params) do
        {
          talk: {
            title: "Modern Rails Architecture",
            description: "A deep dive into Rails architectural patterns",
            speaker: "Jane Doe",
            start_time: event.start_date + 1.hour,
            end_time: event.start_date + 2.hours,
            event_id: event.id
          }
        }
      end

      it "creates a new talk" do
        expect {
          post "/talks", params: valid_params
        }.to change(Talk, :count).by(1)
      end

      it "returns a created status" do
        post "/talks", params: valid_params
        expect(response).to have_http_status(:created)
      end

      it "returns the created talk as JSON" do
        post "/talks", params: valid_params
        json_response = JSON.parse(response.body)

        expect(json_response["title"]).to eq(valid_params[:talk][:title])
        expect(json_response["description"]).to eq(valid_params[:talk][:description])
        expect(json_response["speaker"]).to eq(valid_params[:talk][:speaker])
        expect(json_response["event_id"]).to eq(event.id)
      end

      it "associates the talk with the specified event" do
        post "/talks", params: valid_params

        talk = Talk.last
        expect(talk.event_id).to eq(event.id)
      end
    end

    context "with invalid parameters" do
      let(:invalid_params) do
        {
          talk: {
            title: "",
            description: "Missing required fields",
            speaker: "",
            event_id: event.id
          }
        }
      end

      it "does not create a new talk" do
        expect {
          post "/talks", params: invalid_params
        }.not_to change(Talk, :count)
      end

      it "returns an unprocessable entity status" do
        post "/talks", params: invalid_params
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it "returns validation errors" do
        post "/talks", params: invalid_params
        json_response = JSON.parse(response.body)

        expect(json_response["errors"]).to be_present
        expect(json_response["errors"]["title"]).to include("can't be blank")
        expect(json_response["errors"]["speaker"]).to include("can't be blank")
        expect(json_response["errors"]["start_time"]).to include("can't be blank")
        expect(json_response["errors"]["end_time"]).to include("can't be blank")
      end
    end

    context "when the event does not exist" do
      let(:nonexistent_event_params) do
        {
          talk: {
            title: "My Talk",
            description: "A great talk",
            speaker: "John Smith",
            start_time: Time.current + 1.day,
            end_time: Time.current + 1.day + 1.hour,
            event_id: 999
          }
        }
      end

      it "returns a not found status" do
        post "/talks", params: nonexistent_event_params
        expect(response).to have_http_status(:not_found)
      end

      it "returns an error message" do
        post "/talks", params: nonexistent_event_params
        json_response = JSON.parse(response.body)
        expect(json_response["error"]).to eq("Event not found")
      end
    end
  end
end
