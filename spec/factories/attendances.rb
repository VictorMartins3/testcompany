FactoryBot.define do
  factory :attendance do
    association :participant
    association :talk
  end
end
