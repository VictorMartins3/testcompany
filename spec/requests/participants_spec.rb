require 'rails_helper'

RSpec.describe "Participants", type: :request do
  describe "GET /participants" do
    before do
      create_list(:participant, 3)
    end

    it "returns http success" do
      get "/participants"
      expect(response).to have_http_status(:success)
    end

    it "returns all participants" do
      get "/participants"
      expect(JSON.parse(response.body).size).to eq(3)
    end
  end

  describe "POST /participants" do
    let(:event) { create(:event) }
    let(:valid_attributes) {
      {
        participant: {
          name: "John Doe",
          email: "john@example.com",
          event_id: event.id
        }
      }
    }

    let(:invalid_attributes) {
      {
        participant: {
          name: "",
          email: "",
          event_id: nil
        }
      }
    }

    context "with valid parameters" do
      it "returns http created status" do
        post "/participants", params: valid_attributes
        expect(response).to have_http_status(:created)
      end

      it "creates a new participant" do
        expect {
          post "/participants", params: valid_attributes
        }.to change(Participant, :count).by(1)
      end

      it "returns the created participant" do
        post "/participants", params: valid_attributes
        expect(JSON.parse(response.body)["name"]).to eq("John Doe")
        expect(JSON.parse(response.body)["email"]).to eq("john@example.com")
        expect(JSON.parse(response.body)["event_id"]).to eq(event.id)
      end
    end

    context "with invalid parameters" do
      it "returns http unprocessable entity status" do
        post "/participants", params: invalid_attributes
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it "does not create a new participant" do
        expect {
          post "/participants", params: invalid_attributes
        }.to change(Participant, :count).by(0)
      end

      it "returns validation errors" do
        post "/participants", params: invalid_attributes
        expect(JSON.parse(response.body)["errors"]).to be_present
      end
    end
  end
end
