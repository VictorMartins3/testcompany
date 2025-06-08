class TalksController < ApplicationController
  def create
    @event = Event.find(params[:talk][:event_id])
    @talk = @event.talks.new(talk_params)

    if @talk.save
      render json: @talk, status: :created
    else
      render json: { errors: @talk.errors }, status: :unprocessable_entity
    end
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Event not found" }, status: :not_found
  end

  private

  def talk_params
    params.require(:talk).permit(:title, :description, :speaker, :start_time, :end_time, :event_id)
  end
end
