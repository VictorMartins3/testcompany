# app/serializers/participant_serializer.rb
class ParticipantSerializer < ActiveModel::Serializer
  attributes :id, :name, :email
end
