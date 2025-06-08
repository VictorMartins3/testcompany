class ParticipantsController < ApplicationController
  def index
    participants = Participant.all
    render json: participants.as_json, status: :ok
  end

  def create
    participant = Participant.new(participant_params)
    if participant.save
      render json: participant.as_json, status: :created
    else
      render json: { errors: participant.errors }, status: :unprocessable_entity
    end
  end

  private

  def participant_params
    params.require(:participant).permit(:name, :email, :event_id)
  end
end
