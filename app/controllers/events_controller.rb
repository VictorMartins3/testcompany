class EventsController < ApplicationController
  before_action :set_event, only: [:show, :feedback_report]

  def show
    render json: @event.as_json(include: :talks)
  end

  # GET /events/:id/feedback_report
  def feedback_report
    talks = @event.talks.to_a # Load all the talks
    talk_ids = talks.map(&:id)

    feedbacks_by_talk_id = Feedback
      .where(talk_id: talk_ids)
      .select(:id, :talk_id, :rating, :comment)
      .group_by(&:talk_id)

    talk_feedbacks_report = talks.map do |talk|
      current_talk_feedbacks = feedbacks_by_talk_id[talk.id] || []

      average_rating = if current_talk_feedbacks.any?
                         (current_talk_feedbacks.sum(&:rating).to_f / current_talk_feedbacks.size).round(2)
                       else
                         nil
                       end
      feedback_count = current_talk_feedbacks.size
      comments = current_talk_feedbacks.map(&:comment)

      {
        talk_id: talk.id,
        talk_title: talk.title,
        average_rating: average_rating,
        feedback_count: feedback_count,
        comments: comments
      }
    end
    render json: {
      event_id: @event.id,
      event_title: @event.title,
      talk_feedbacks: talk_feedbacks_report
    }
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

  def set_event
    @event = Event.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Event not found" }, status: :not_found
  end
end
