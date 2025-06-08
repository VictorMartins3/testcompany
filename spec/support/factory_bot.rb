RSpec.configure do |config|
  config.include FactoryBot::Syntax::Methods
end

FactoryBot.define do
  # Define a sequence for common attributes like emails
  sequence :email do |n|
    "user#{n}@example.com"
  end
end
