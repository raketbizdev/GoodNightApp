require 'rails_helper'
# rspec ./spec/requests/home_spec.rb    
RSpec.describe HomeController, type: :controller do
  describe 'GET #index' do
    before do
      get :index
    end

    it 'returns http success' do
      expect(response).to have_http_status(:success)
    end

    it 'returns the correct JSON response' do
      json_response = JSON.parse(response.body)

      expect(json_response['status']).to eq('ok')
      expect(json_response['message']).to eq('Welcome to Good Night API!')
    end
  end
end