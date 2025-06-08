class EventsController < ApplicationController
  def show
    @event = Event.find(params[:id])
    render json: @event.as_json(include: :talks)
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Event not found" }, status: :not_found
  end

  def create
    @event = Event.new(event_params)

    if @event.save
      render json: @event, status: :created
    else
      render json: { errors: @event.errors }, status: :unprocessable_entity
    end
  end

  private

  def event_params
    params.require(:event).permit(:title, :description, :location, :start_date, :end_date)
  end
end
