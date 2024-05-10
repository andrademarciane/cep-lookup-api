class Api::AddressSerializer
  def initialize(address)
    @address = address
  end

  def serialize
    {
      cep: @address['cep'],
      logradouro: @address['logradouro'],
      complemento: @address['complemento'],
      bairro: @address['bairro'],
      localidade: @address['localidade'],
      uf: @address['uf'],
      endereco: endereco
    }.to_json
  end

  private

  def endereco
    address = @address['logradouro']
    address += ", #{@address['complemento']}" unless @address['complemento'].blank?
    "#{address} - #{@address['bairro']}, #{@address['localidade']} - #{@address['uf']}"
  end
end
