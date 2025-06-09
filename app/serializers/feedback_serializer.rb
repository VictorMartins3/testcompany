# app/serializers/feedback_serializer.rb
class FeedbackSerializer < ActiveModel::Serializer
  attributes :id, :rating, :comment, :created_at, :participant_id, :talk_id

  belongs_to :participant
  belongs_to :talk
end
