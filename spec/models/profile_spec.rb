require 'rails_helper'

# rspec ./spec/models/profile_spec.rb
RSpec.describe Profile, type: :model do
  include Devise::Test::IntegrationHelpers

  let(:user) { FactoryBot.create(:user) }
  let(:profile) { FactoryBot.create(:profile) }
  def authenticated_header(user)
    token = Warden::JWTAuth::UserEncoder.new.call(user, :user, nil).first
    # puts "Token: #{token}"
    { 'Authorization': "Bearer #{token}" }
  end

  describe '#full_name' do
    
    it 'returns the full name if both first_name and last_name are present' do
      expect(profile.full_name).to eq("#{profile.first_name} #{profile.last_name}")
    end

    it 'returns "No name" if either first_name or last_name is missing' do
      profile.update!(first_name: '')
      expect(profile.full_name).to eq('No name')

      profile.update!(last_name: '')
      expect(profile.full_name).to eq('No name')
    end
  end

  describe '#update_profile' do
    it 'returns a hash containing the updated profile and success message if the update is successful' do
      result = profile.update_profile(first_name: 'Jane')
      expect(result[:profile]).to eq(profile)
      expect(result[:message]).to eq('Profile updated successfully.')
      expect(result[:status]).to eq(:ok)
      expect(result[:followers_count]).to eq(user.followers.count)
      expect(result[:following_count]).to eq(user.following.count)
    end
  end
end