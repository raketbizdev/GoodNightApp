require 'rails_helper'

RSpec.describe "Api::V1::Users::Sessions", type: :request do
  let(:user) { create(:user) }

  describe "POST /api/v1/users/sign_in" do
    context "with valid credentials" do
      let(:user) { create(:user) }
  
      it "returns a JWT token and user data" do
        post '/api/v1/users/sign_in', params: { _jsonapi: { user: { email: user.email, password: 'password123' } } }
  
        expect(response).to have_http_status(:success)
        expect(response.content_type).to eq("application/json; charset=utf-8")
        json_response = JSON.parse(response.body)
        expect(json_response['message']).to eq(I18n.t('api.v1.users.sessions.logged_in'))
        expect(json_response['user']['email']).to eq(user.email)
        expect(json_response['token']).not_to be_nil
      end
    end
  
    context "with invalid credentials" do
      let(:user) { create(:user) }
  
      it "returns an unauthorized error" do
        post '/api/v1/users/sign_in', params: { _jsonapi: { user: { email: user.email, password: 'wrong_password' } } }
  
        expect(response).to have_http_status(:unauthorized)
        expect(response.content_type).to eq("application/json; charset=utf-8")
        json_response = JSON.parse(response.body)
        expect(json_response['error']).to eq(I18n.t('api.v1.users.sessions.invalid_email_password'))
      end
    end
  end
  describe "DELETE /api/v1/users/sign_out" do
    context "when user is logged in" do
      it "logs out the user" do
        # Log in the user first
        post '/api/v1/users/sign_in', params: { _jsonapi: { user: { email: user.email, password: 'password' } } }
        token = JSON.parse(response.body)['token']

        # Log out the user
        delete '/api/v1/users/sign_out', headers: { 'Authorization': "Bearer #{token}" }

        expect(response).to have_http_status(:success)
        expect(response.content_type).to eq("application/json; charset=utf-8")
        json_response = JSON.parse(response.body)
        expect(json_response['message']).to eq(I18n.t('api.v1.users.sessions.logged_out'))
      end
    end
    context "when user is not logged in" do
      it "returns unauthorized error" do
        delete '/api/v1/users/sign_out'

        expect(response).to have_http_status(:unauthorized)
        expect(response.content_type).to eq("application/json; charset=utf-8")
        json_response = JSON.parse(response.body)
        expect(json_response['error']).to eq("You need to sign in or sign up before continuing.")
      end
    end
  end
end