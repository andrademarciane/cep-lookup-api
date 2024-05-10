require 'rails_helper'

RSpec.describe Api::AddressSerializer do
  let(:address) do
    {
      'cep' => '12345-678',
      'logradouro' => 'Rua Teste',
      'complemento' => 'Apto 101',
      'bairro' => 'Centro',
      'localidade' => 'Cidade Teste',
      'uf' => 'TS'
    }
  end

  subject { described_class.new(address) }

  describe '#serialize' do
    it 'includes all attributes' do
      serialized_address = subject.serialize
      parsed_json = JSON.parse(serialized_address)

      expect(parsed_json.keys).to contain_exactly('cep', 'logradouro', 'complemento', 'bairro', 'localidade', 'uf', 'endereco')
    end

    it 'formats endereco correctly' do
      serialized_address = subject.serialize
      parsed_json = JSON.parse(serialized_address)

      expect(parsed_json['endereco']).to eq('Rua Teste, Apto 101 - Centro, Cidade Teste - TS')
    end

    context 'when complemento is blank' do
      before { address.delete('complemento') }

      it 'does not include complemento in endereco' do
        serialized_address = subject.serialize
        parsed_json = JSON.parse(serialized_address)

        expect(parsed_json['endereco']).to eq('Rua Teste - Centro, Cidade Teste - TS')
      end
    end
  end
end
