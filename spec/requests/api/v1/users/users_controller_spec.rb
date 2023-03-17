require 'rails_helper'
# rspec ./spec/requests/api/v1/users/users_controller_spec.rb
RSpec.describe Api::V1::UsersController, type: :request do
  let!(:user) { create(:user) }
  let(:headers) { { 'Authorization' => "Bearer #{user.generate_jwt}" } }

  describe 'GET #index' do
    it 'returns http success' do
      get '/api/v1/users', headers: headers

      expect(response).to have_http_status(:success)
    end

    it 'returns the correct number of users', :index_user_count do
      get :index
      json_response = JSON.parse(response.body)

      expect(json_response['user_count']).to eq(User.count)
    end

    it 'returns the correct followers and followings count', :index_follow_counts do
      get :index
      json_response = JSON.parse(response.body)

      expect(json_response['followers_count']).to eq(user.followers.count)
      expect(json_response['followings_count']).to eq(user.following.count)
    end

    it 'returns the expected user data structure', :index_user_data_structure do
      get :index
      json_response = JSON.parse(response.body)
      user_data = json_response['users'].first

      expect(user_data.keys).to contain_exactly(
        'id', 'email', 'full_name', 'followers_count',
        'followings_count', 'sleep_duration', 'sleep_count', 'created_at'
      )
    end
  end
end