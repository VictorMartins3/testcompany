# app/serializers/feedback_serializer.rb
class FeedbackSerializer < ActiveModel::Serializer
  attributes :id, :rating, :comment, :created_at

  belongs_to :participant
  belongs_to :talk
end
