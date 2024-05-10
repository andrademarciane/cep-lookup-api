class Api::AddressCreatorService
  attr_reader :user_id, :address_data

  def initialize(user_id, address_data)
    @user_id = user_id
    @address_data = address_data
  end

  def create_or_update_address
    address = find_or_initialize_address
    address.update(format_address_data)
    address
  end

  private

  def format_address_data
    {
      cep: address_data['cep'],
      street: address_data['logradouro'],
      neighborhood: address_data['bairro'],
      city: address_data['localidade'],
      state: address_data['uf']
    }
  end

  def find_or_initialize_address
    Address.find_or_initialize_by(user_id: user_id, cep: address_data['cep'])
  end
end