FactoryBot.define do
  factory :user do
    email { Faker::Internet.email }
    password { 'password123' }
    password_confirmation { 'password123' }

    before(:create) do |user|
      user.jti = SecureRandom.uuid
      user.save!
      user.token = Warden::JWTAuth::UserEncoder.new.call(user, :user, nil)
    end
  end
end