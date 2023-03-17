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
        expect(response).to have_http_status(:ok)
        json_response = JSON.parse(response.body)
        expect(json_response["full_name"]).to eq(user.profile&.full_name)
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
end