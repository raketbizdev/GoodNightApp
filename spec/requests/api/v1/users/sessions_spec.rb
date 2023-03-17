require 'rails_helper'
# rspec ./spec/requests/api/v1/users/sessions_spec.rb
RSpec.describe Api::V1::Users::SessionsController, type: :request do
  include Devise::Test::IntegrationHelpers

  let(:user) { FactoryBot.create(:user) }
  def authenticated_header(user)
    token = Warden::JWTAuth::UserEncoder.new.call(user, :user, nil)
    { 'Authorization': "Bearer #{token}" }
  end

  describe 'POST #create' do
    context 'with valid credentials' do
      it 'returns a successful response with user data and JWT token' do
        post '/api/v1/users/sign_in', params: { _jsonapi: { user: { email: user.email, password: user.password } } }

        expect(response).to have_http_status(:success)
        json_response = JSON.parse(response.body)

        expect(json_response['message']).to eq('You are logged in.')
        expect(json_response['user']['id']).to eq(user.id)
        expect(json_response['user']['email']).to eq(user.email)
        expect(json_response['token']).not_to be_nil
      end
    end
    context 'with invalid credentials' do
      it 'returns an unauthorized response with an error message' do
        post '/api/v1/users/sign_in', params: { _jsonapi: { user: { email: user.email, password: 'wrong_password' } } }

        expect(response).to have_http_status(:unauthorized)
        json_response = JSON.parse(response.body)

        expect(json_response['error']).to eq(I18n.t('api.v1.users.sessions.invalid_email_password'))
      end
    end
  end
end