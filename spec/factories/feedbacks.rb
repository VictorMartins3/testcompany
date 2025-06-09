FactoryBot.define do
  factory :feedback do
    comment { Faker::Lorem.sentence }
    rating { rand(1..5) }
    association :participant
    association :talk
  end
end
