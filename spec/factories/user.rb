FactoryBot.define do
  factory :user do
    email { Faker::Internet.email }
    password { 'password' }
    password_confirmation { 'password' }

    transient do
      token { nil }
    end

    after(:create) do |user, evaluator|
      if evaluator.token.present?
        user.token = evaluator.token
      else
        user.token = Warden::JWTAuth::UserEncoder.new.call(user, :user, nil)
      end
      create(:profile, user: user, first_name: '', last_name: '')
    end
  end
end