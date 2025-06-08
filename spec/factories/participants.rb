FactoryBot.define do
  factory :participant do
    name { Faker::Name.name }
    email { Faker::Internet.email }
    event
  end
end
