require 'rails_helper'
# rspec ./spec/requests/api/v1/users/users_controller_spec.rb
RSpec.describe Api::V1::UsersController, type: :request do
  include Devise::Test::IntegrationHelpers

  let(:user) { FactoryBot.create(:user) }

  def authenticated_header(user)
    token = Warden::JWTAuth::UserEncoder.new.call(user, :user, nil).first
    # puts "Token: #{token}"
    { 'Authorization': "Bearer #{token}" }
  end
  # rspec ./spec/requests/api/v1/users/users_controller_spec.rb -e 'GET /api/v1/users'
  describe "GET /api/v1/users" do
    before do
      sign_in user
    end

    it "returns a list of all users and user statistics" do
      get "/api/v1/users", headers: authenticated_header(user)

      expect(response).to have_http_status(:ok)

      json_response = JSON.parse(response.body)

      expect(json_response).to have_key("users")
      expect(json_response["users"]).to be_an(Array)
      expect(json_response["users"].first).to have_key("id")
      expect(json_response["users"].first).to have_key("email")
      expect(json_response["users"].first).to have_key("full_name")
      expect(json_response["users"].first).to have_key("followers_count")
      expect(json_response["users"].first).to have_key("followings_count")
      expect(json_response["users"].first).to have_key("sleep_duration")
      expect(json_response["users"].first).to have_key("sleep_count")
      expect(json_response["users"].first).to have_key("created_at")

      expect(json_response).to have_key("user_count")
      expect(json_response).to have_key("followers_count")
      expect(json_response).to have_key("followings_count")
    end
  end
# rspec ./spec/requests/api/v1/users/users_controller_spec.rb -e 'GET /api/v1/users/:id'
  describe "GET /api/v1/users/:id" do

    before do
      sign_in user
    end

    context "when user is authenticated" do
      before do
        get "/api/v1/users/#{user.id}", headers: authenticated_header(user)
      end

      it "returns a 200 status code" do
        expect(response.status).to eq(200)
      end

      it 'returns the user\'s email' do
        expect(response).to have_http_status(:ok)
        json_response = JSON.parse(response.body)
        expect(json_response['email']).to eq(user.email)
      end

      it "returns the user's full name" do
        user = create(:user)
        get api_v1_user_path(user), headers: authenticated_header(user)
        expect(response).to have_http_status(:ok)
        json_response = JSON.parse(response.body)
        
        if user.profile.first_name.blank? && user.profile.last_name.blank?
          expected_full_name = "No name"
        else
          expected_full_name = user.profile.full_name
        end
        
        expect(json_response["full_name"]).to eq(expected_full_name)
      end

      it "returns the number of followers for the user" do
        expect(response).to have_http_status(:ok)
        json_response = JSON.parse(response.body)
        expect(json_response["followers_count"]).to eq(user.followers.count)
      end

      it "returns the number of followings for the user" do
        expect(response).to have_http_status(:ok)
        json_response = JSON.parse(response.body)
        expect(json_response["following_count"]).to eq(user.following.count)
      end

      it "returns a list of followers for the user" do
        expect(response).to have_http_status(:ok)
        json_response = JSON.parse(response.body)
        expect(json_response["followers"]).to be_an(Array).or be_nil
        expect(json_response["followers"].first&.[]("id")).to eq(user.followers.first&.id)
        expect(json_response["followers"].first&.[]("name")).to eq(user.followers.first&.profile&.full_name)
      end

      it "returns a list of followings for the user" do
        expect(response).to have_http_status(:ok)
        json_response = JSON.parse(response.body)
        expect(json_response["followings"]).to be_an(Array).or be_nil
        if user.followers.empty?
          expect(json_response["followers"].first).to be_nil
        else
          expect(json_response["followers"].first["id"]).to eq(user.followers.first.id)
          expect(json_response["followers"].first["name"]).to eq(user.followers.first.profile&.full_name)
        end
        
        expect(json_response["followings"]).to be_an(Array)
        if user.following.empty?
          expect(json_response["followings"].first).to be_nil
        else
          expect(json_response["followings"].first["id"]).to eq(user.following.first.id)
          expect(json_response["followings"].first["name"]).to eq(user.following.first.profile&.full_name)
          expect(json_response["followings"].first["total_duration"]).to eq(user.following.first.sleep_summary[:total_duration])
          expect(json_response["followings"].first["sleep_count"]).to eq(user.following.first.sleep_summary[:sleep_count])
        end
      end

      it "returns a list of sleep records for the user" do
        expect(response).to have_http_status(:ok)
        json_response = JSON.parse(response.body)
        
        expect(json_response["sleep_records"]).to be_an(Array).or be_nil
        if json_response["sleep_records"].present?
          expect(json_response["sleep_records"].first["id"]).to eq(user.sleep_records.first.id)
          expect(json_response["sleep_records"].first["start_time"]).to eq(user.sleep_records.first.start_time)
          expect(json_response["sleep_records"].first["end_time"]).to eq(user.sleep_records.first.end_time)
          expect(json_response["sleep_records"].first["duration"]).to eq(user.sleep_records.first.duration)
        end
      end

      it "returns the total sleep duration for the user" do
        expect(response).to have_http_status(:ok)
        json_response = JSON.parse(response.body)
        expect(json_response["total_duration"]).to eq(user.sleep_summary[:total_duration])
      end

      it "returns the sleep count for the user" do
        expect(response).to have_http_status(:ok)
        json_response = JSON.parse(response.body)
        expect(json_response["sleep_count"]).to eq(user.sleep_summary[:sleep_count])
      end
    end

    context "when user is not authenticated" do
      before do
        get "/api/v1/users/#{user.id}"
      end

      it "returns a 401 status code" do
        expect(response.status).to eq(401)
      end
    end
  end
  # rspec ./spec/requests/api/v1/users/users_controller_spec.rb -e 'PUT /api/v1/users/:id'
  describe 'PUT /api/v1/users/:id' do
    let(:other_user) { create(:user) }
    let(:profile_params) { { first_name: 'Updated First Name', last_name: 'Updated Last Name' } }

    context 'when the user is authenticated' do
      before { request.headers.merge!(authenticated_header(user)) }

      context 'when updating their own profile' do
        it 'updates the profile and returns the updated profile' do
          put api_v1_user_path(user), params: { profile: profile_params }, headers: authenticated_header(user)

          expect(response).to have_http_status(:ok)
          json_response = JSON.parse(response.body)
          expect(json_response['success']).to be true
          expect(json_response['profile']['first_name']).to eq(profile_params[:first_name])
          expect(json_response['profile']['last_name']).to eq(profile_params[:last_name])
        end

        it 'returns an error when the update fails' do
          allow_any_instance_of(User).to receive(:update_profile).and_return(
            status: :unprocessable_entity,
            errors: ['Error message']
          )

          put api_v1_user_path(user), params: { profile: profile_params }, headers: authenticated_header(user)

          expect(response).to have_http_status(:unprocessable_entity)
          json_response = JSON.parse(response.body)
          expect(json_response['success']).to be false
          expect(json_response['errors']).to include('Error message')
        end
      end

      context 'when updating another user\'s profile' do
        it 'returns unauthorized' do
          put api_v1_user_path(other_user), params: { profile: profile_params }, headers: authenticated_header(user)

          expect(response).to have_http_status(:unauthorized)
          json_response = JSON.parse(response.body)
          expect(json_response['success']).to be false
          expect(json_response['error']).to eq('You are not authorized to update this profile.')
        end
      end
    end

    context 'when the user is not authenticated' do
      it 'returns unauthorized' do
        put api_v1_user_path(user), params: { profile: profile_params }

        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
  # rspec ./spec/requests/api/v1/users/users_controller_spec.rb -e 'POST /api/v1/users/:id/follow'
  describe "POST /api/v1/users/:id/follow" do
    context "when the user is signed in and authenticated" do
      let(:user_to_follow) { FactoryBot.create(:user) }

      it "follows the user successfully" do
        post "/api/v1/users/#{user_to_follow.id}/follow", headers: authenticated_header(user)

        expect(response).to have_http_status(:ok)
        json_response = JSON.parse(response.body)
        expect(json_response["success"]).to be_truthy
        expect(json_response["message"]).to eq("You are now following #{user_to_follow.email}.")
        expect(user.following).to include(user_to_follow)
      end

      it "returns an error when trying to follow a non-existent user" do
        post "/api/v1/users/999/follow", headers: authenticated_header(user)

        expect(response).to have_http_status(:not_found)
        json_response = JSON.parse(response.body)
        expect(json_response["success"]).to be_falsey
        expect(json_response["error"]).to eq("User not found.")
      end

      it "returns an error when trying to follow oneself" do
        post "/api/v1/users/#{user.id}/follow", headers: authenticated_header(user)

        expect(response).to have_http_status(:unprocessable_entity)
        json_response = JSON.parse(response.body)
        expect(json_response["success"]).to be_falsey
        expect(json_response["error"]).to eq("You cannot follow yourself.")
      end

      it "returns an error when trying to follow a user that is already being followed" do
        user.following << user_to_follow
        post "/api/v1/users/#{user_to_follow.id}/follow", headers: authenticated_header(user)

        expect(response).to have_http_status(:unprocessable_entity)
        json_response = JSON.parse(response.body)
        expect(json_response["success"]).to be_falsey
        expect(json_response["error"]).to eq("You are already following this user.")
      end
    end

    context "when the user is not signed in or authenticated" do
      it "returns an unauthorized error" do
        post "/api/v1/users/#{user.id}/follow"
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
# rspec ./spec/requests/api/v1/users/users_controller_spec.rb -e 'DELETE /api/v1/users/:id/unfollow'
  describe "DELETE /api/v1/users/:id/unfollow" do
    context "when the user is signed in and authenticated" do
      let(:user_to_unfollow) { FactoryBot.create(:user) }

      before do
        user.following << user_to_unfollow
      end

      it "unfollows the user successfully" do
        delete "/api/v1/users/#{user_to_unfollow.id}/unfollow", headers: authenticated_header(user)

        expect(response).to have_http_status(:ok)
        json_response = JSON.parse(response.body)
        expect(json_response["success"]).to be_truthy
        expect(json_response["message"]).to eq("You have unfollowed #{user_to_unfollow.email}.")
        expect(user.following).not_to include(user_to_unfollow)
      end

      it "returns an error when trying to unfollow a non-existent user" do
        delete "/api/v1/users/999/unfollow", headers: authenticated_header(user)

        expect(response).to have_http_status(:not_found)
        json_response = JSON.parse(response.body)
        expect(json_response["success"]).to be_falsey
        expect(json_response["error"]).to eq("User not found.")
      end

      it "returns an error when trying to unfollow oneself" do
        delete "/api/v1/users/#{user.id}/unfollow", headers: authenticated_header(user)

        expect(response).to have_http_status(:unprocessable_entity)
        json_response = JSON.parse(response.body)
        expect(json_response["success"]).to be_falsey
        expect(json_response["error"]).to eq("You cannot unfollow yourself.")
      end

      it "returns an error when trying to unfollow a user that is not being followed" do
        user.following.delete(user_to_unfollow)
        delete "/api/v1/users/#{user_to_unfollow.id}/unfollow", headers: authenticated_header(user)

        expect(response).to have_http_status(:unprocessable_entity)
        json_response = JSON.parse(response.body)
        expect(json_response["success"]).to be_falsey
        expect(json_response["error"]).to eq("You are not following this user.")
      end
    end

    context "when the user is not signed in or authenticated" do
      it "returns an unauthorized error" do
        delete "/api/v1/users/#{user.id}/unfollow"
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
# rspec ./spec/requests/api/v1/users/users_controller_spec.rb -e 'POST /api/v1/users/:id/clock_in'
  describe "POST /api/v1/users/:id/clock_in" do
    context "when the user is signed in and authenticated" do
      it "clocks the user in successfully" do
        post "/api/v1/users/#{user.id}/clock_in", headers: authenticated_header(user)

        expect(response).to have_http_status(:created)
        json_response = JSON.parse(response.body)
        expect(json_response["success"]).to be_truthy
        expect(json_response["message"]).to eq("Clock in successful.")
        expect(json_response["sleep"]["start_time"]).not_to be_nil
        expect(user.sleeps.count).to eq(1)
      end

      it "returns an error when the user is not authorized to clock in" do
        another_user = FactoryBot.create(:user)
        post "/api/v1/users/#{another_user.id}/clock_in", headers: authenticated_header(user)

        expect(response).to have_http_status(:unauthorized)
        json_response = JSON.parse(response.body)
        expect(json_response["success"]).to be_falsey
        expect(json_response["message"]).to eq("You are not authorized to perform this action.")
        expect(user.sleeps.count).to eq(0)
      end

      it "returns an error when the user is already clocked in" do
        sleep_record = FactoryBot.create(:sleep, user: user, end_time: nil)
        post "/api/v1/users/#{user.id}/clock_in", headers: authenticated_header(user)

        expect(response).to have_http_status(:unprocessable_entity)
        json_response = JSON.parse(response.body)
        expect(json_response["success"]).to be_falsey
        expect(json_response["message"]).to eq("You must clock out before clocking in again.")
        expect(user.sleeps.count).to eq(1)
      end
    end

    context "when the user is not signed in or authenticated" do
      it "returns an unauthorized error" do
        post "/api/v1/users/#{user.id}/clock_in"
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
# rspec ./spec/requests/api/v1/users/users_controller_spec.rb -e 'POST /api/v1/users/:id/clock_out'

  describe 'POST /api/v1/users/:id/clock_out' do
    let(:user) { FactoryBot.create(:user) }

    context 'when the user is signed in and authenticated' do
      let!(:sleep_record) { FactoryBot.create(:sleep, user: user, end_time: nil) }

      before do
        post "/api/v1/users/#{user.id}/clock_out", headers: authenticated_header(user)
      end

      context 'when the user has a sleep record that is not already clocked out' do
        it 'updates the end time for the sleep record' do
          sleep_record.reload
          expect(sleep_record.end_time).not_to be_nil
        end
      
        it 'returns a success response with the updated sleep record' do
          expect(response).to have_http_status(:ok)
          json_response = JSON.parse(response.body)
          expect(json_response['success']).to be_truthy
          expect(json_response['message']).to eq('Clock out successful.')
          expect(json_response['sleep']['id']).to eq(sleep_record.id)
          expect(json_response['sleep']['end_time']).not_to be_nil
        end
      end

      context 'when the user has no sleep records or all sleep records are already clocked out' do
        before do
          FactoryBot.create(:sleep, user: user, end_time: Time.now)
          post "/api/v1/users/#{user.id}/clock_out", headers: authenticated_header(user)
        end

        it 'returns an error response' do
          expect(response).to have_http_status(:unprocessable_entity)
          json_response = JSON.parse(response.body)
          expect(json_response['success']).to be_falsey
          expect(json_response['message']).to eq('You must clock in before clocking out.')
        end
      end
    end

    context 'when the user is not signed in' do
      let(:non_existent_user_id) { User.maximum(:id).to_i + 1 }
      
      before do
        post "/api/v1/users/#{non_existent_user_id}/clock_out"
      end
    
      it 'returns an unauthorized response' do
        expect(response).to have_http_status(:unauthorized)
        json_response = JSON.parse(response.body)
      
        expect(json_response['success']).to be_falsey
        expect(json_response['message']).to be_nil
      end
    end

    context 'when the user is signed in but calling a non-existent user' do
      let(:non_existent_user_id) { User.maximum(:id).to_i + 1 }
    
      before do
        post "/api/v1/users/#{non_existent_user_id}/clock_out", headers: authenticated_header(user)
      end
    
      it 'returns a not found response' do
        expect(response).to have_http_status(:not_found)
        json_response = JSON.parse(response.body)
        expect(json_response['success']).to be_falsey
        expect(json_response['error']).to eq('User not found.')
      end
    end

    context 'when the user is signed in but not authorized' do
      let(:other_user) { FactoryBot.create(:user) }

      before do
        post "/api/v1/users/#{user.id}/clock_out", headers: authenticated_header(other_user)
      end

      it 'returns an unauthorized response' do
        expect(response).to have_http_status(:unauthorized)
        json_response = JSON.parse(response.body)
        expect(json_response['success']).to be_falsey
        expect(json_response['message']).to eq('You are not authorized to perform this action.')
      end
    end
  end
end