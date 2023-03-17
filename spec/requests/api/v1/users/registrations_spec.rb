require 'rails_helper'

RSpec.describe "Api::V1::Users::Registrations", type: :request do
  describe 'POST /api/v1/users/signup' do
    let(:url) { '/api/v1/users/signup' }

    context 'with valid parameters' do
      let(:valid_params) do
        {
          user: attributes_for(:user)
        }
      end

      it 'creates a new user' do
        expect { post url, params: valid_params }.to change(User, :count).by(1)
      end

      it 'returns a success message' do
        post url, params: valid_params
        json_response = JSON.parse(response.body)
        expect(json_response['success']).to be(true)
        expect(json_response['message']).to include('User with email')
      end
    end

    context 'with invalid parameters' do
      let(:invalid_params) do
        {
          user: attributes_for(:user, email: '')
        }
      end

      it 'does not create a new user' do
        expect { post url, params: invalid_params }.not_to change(User, :count)
      end

      it 'returns an error message' do
        post url, params: invalid_params
        json_response = JSON.parse(response.body)
        expect(json_response['success']).to be(false)
        expect(json_response['errors']).to include("Email can't be blank")
      end
    end
    context 'with invalid email format' do
      let(:invalid_email_params) do
        {
          user: attributes_for(:user, email: 'invalidemail')
        }
      end

      it 'does not create a new user' do
        expect { post url, params: invalid_email_params }.not_to change(User, :count)
      end

      it 'returns an error message' do
        post url, params: invalid_email_params
        json_response = JSON.parse(response.body)
        expect(json_response['success']).to be(false)
        expect(json_response['errors']).to include('Email is invalid')
      end
    end
  end
end