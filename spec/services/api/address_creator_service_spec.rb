require 'rails_helper'

RSpec.describe Api::AddressCreatorService, type: :service do
  let(:user) { create(:user) }
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

  describe '#create_or_update_address' do
    subject { described_class.new(user, address_data).create_or_update_address }

    context 'when the address does not exist' do
      it 'creates a new address with correct attributes' do
        expect { subject }.to change { user.addresses.count }.by(1)
        expect(user.addresses.last).to have_attributes(
          cep: cep,
          street: address_data['logradouro'],
          neighborhood: address_data['bairro'],
          city: address_data['localidade'],
          state: address_data['uf']
        )
      end
    end

    context 'when the address already exists' do
      let!(:existing_address) { create(:address, user: user, cep: cep) }

      it 'updates the existing address with correct attributes' do
        expect { subject }.not_to change { user.addresses.count }
        expect(existing_address.reload).to have_attributes(
          cep: cep,
          street: address_data['logradouro'],
          neighborhood: address_data['bairro'],
          city: address_data['localidade'],
          state: address_data['uf']
        )
      end
    end
  end
end