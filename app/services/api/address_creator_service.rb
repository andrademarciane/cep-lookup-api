# frozen_string_literal: true

class Api::AddressCreatorService
  attr_reader :user, :address_data

  def initialize(user, address_data)
    @user = user
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
    user.addresses.find_or_initialize_by(cep: address_data['cep'])
  end
end
