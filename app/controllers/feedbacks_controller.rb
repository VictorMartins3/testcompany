class FeedbacksController < ApplicationController
  before_action :set_talk

  # POST /talks/:talk_id/feedbacks
  def create
    # Assuming participant_id is sent in the request body
    @feedback = @talk.feedbacks.new(feedback_params)

    if @feedback.save
      render json: @feedback, status: :created
    else
      render json: { errors: @feedback.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def set_talk
    @talk = Talk.find(params[:talk_id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Talk not found" }, status: :not_found
  end

  def feedback_params
    params.require(:feedback).permit(:participant_id, :rating, :comment)
  end
end
