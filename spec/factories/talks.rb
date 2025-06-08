FactoryBot.define do
  factory :talk do
    title { Faker::Company.catch_phrase }
    description { Faker::Lorem.paragraph(sentence_count: 2) }
    speaker { "#{Faker::Name.first_name} #{Faker::Name.last_name}" }

    # Ensure talk times are within the associated event's timeframe
    start_time { |t| t.association(:event).start_date + 4.hours }
    end_time { |t| t.association(:event).start_date + 5.hours }

    association :event
  end
end
