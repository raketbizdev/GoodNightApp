FactoryBot.define do
  factory :sleep do
    user # assumes you have a :user factory defined
    start_time { Time.now }
    end_time { nil }
  end
end