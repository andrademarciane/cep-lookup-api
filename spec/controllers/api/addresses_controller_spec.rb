# spec/controllers/api/addresses_controller_spec.rb
require 'rails_helper'

RSpec.describe Api::AddressesController, type: :controller do
  describe 'GET #show' do
    let(:user) { create(:user) }
    let(:token) { 'fake_token' }
    let(:headers) { { 'Authorization' => "Bearer #{token}" } }

    before do
      allow(controller).to receive(:authenticate_user).and_return(true)
      allow(controller).to receive(:current_user).and_return(user)
    end

    context 'when address is successfully fetched' do
      let(:cep) { '12345678' }
      let(:address_data) do
        {
          'cep' => cep,
          'logradouro' => 'Rua Teste',
          'bairro' => 'Bairro Teste',
          'localidade' => 'Cidade Teste',
          'uf' => 'TS'
        }
      end

      before do
        allow(controller).to receive(:current_user).and_return(user)
        allow(Api::AddressLookupService).to receive(:new).with(user, cep).and_return(double('address_lookup_service', lookup: address_data))
      end

      it 'returns status 200 with the address data' do
        get :show, params: { cep: cep }
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)['address']).to eq(address_data)
      end
    end

    context 'when address fetch fails' do
      let(:cep) { 'invalid_cep' }

      before do
        allow(controller).to receive(:current_user).and_return(user)
        allow(Api::AddressLookupService).to receive(:new).with(user, cep).and_raise(StandardError.new('Failed to fetch address'))
      end

      it 'returns status 422 with error message' do
        get :show, params: { cep: cep }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)['error']).to eq('Failed to fetch address')
      end
    end
  end
end