require 'rails_helper'

RSpec.describe Api::AddressLookupService, type: :service do
  let(:user) { create(:user) }
  let(:cep) { '01001-000' } # CEP válido para teste (Av. Paulista, São Paulo - SP)

  describe '#lookup' do
    context 'when given a valid CEP' do
      it 'returns the address' do
        VCR.use_cassette('valid_cep_lookup') do
          service = Api::AddressLookupService.new(user, cep)
          address = service.lookup

          expect(address).to have_attributes(
            cep: address.cep,
            street: address.street,
            neighborhood: address.neighborhood,
            city: address.city,
            state: address.state
          )
        end
      end
    end

    context 'when given an invalid CEP' do
      let(:invalid_cep) { '00000000' }

      it 'raises an error' do
        VCR.use_cassette('invalid_cep_lookup') do
          service = Api::AddressLookupService.new(user, invalid_cep)
          expect { service.lookup }.to raise_error(StandardError)
        end
      end
    end

    context 'when there is a failure in address fetching' do
      let(:invalid_response) { instance_double('Net::HTTPResponse', is_a?: false, message: 'Not Found') }

      it 'raises an error' do
        allow(Net::HTTP).to receive(:get_response).and_return(invalid_response)
        service = Api::AddressLookupService.new(user, cep)
        expect { service.lookup }.to raise_error(StandardError)
      end
    end
  end
end
