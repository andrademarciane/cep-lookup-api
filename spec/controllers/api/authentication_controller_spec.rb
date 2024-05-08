require 'rails_helper'

RSpec.describe Api::AuthenticationController, type: :controller do
  describe 'POST #create' do
    let!(:user) { create(:user) }

    context 'with valid authentication parameters' do
      before do
        post :create, params: { authentication: { email: 'user.api@example.com', password: 'password123' } }
      end

      it 'returns a valid token' do
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)).to have_key('token')
      end
    end

    context 'with invalid email' do
      before do
        post :create, params: { authentication: { email: 'invalid@example.com', password: 'password123' } }
      end

      it 'returns unauthorized error' do
        expect(response).to have_http_status(:unauthorized)
        expect(JSON.parse(response.body)['error']).to eq('Invalid email or password')
      end
    end

    context 'with invalid password' do
      before do
        post :create, params: { authentication: { email: 'user.api@example.com', password: 'invalidpassword' } }
      end

      it 'returns unauthorized error' do
        expect(response).to have_http_status(:unauthorized)
        expect(JSON.parse(response.body)['error']).to eq('Invalid email or password')
      end
    end
  end
end
