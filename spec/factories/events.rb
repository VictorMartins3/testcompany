FactoryBot.define do
  factory :event do
    title { Faker::Company.name + " Conference" }
    description { Faker::Lorem.paragraph(sentence_count: 3) }
    location { "#{Faker::Address.city}, #{Faker::Address.country}" }
    start_date { Faker::Time.forward(days: 30, period: :morning) }
    end_date { |e| e.start_date + 2.days }
  end
end
