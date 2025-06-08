# app/serializers/talk_serializer.rb
class TalkSerializer < ActiveModel::Serializer
  attributes :id, :title, :description, :speaker, :start_time, :end_time
end
