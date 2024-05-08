require 'net/http'
require 'json'
require 'concurrent'

class Api::AddressLookupService
  VIA_CEP_URL = 'https://viacep.com.br/ws/'
  CACHE_EXPIRATION = 3600

  attr_reader :user, :cep

  def initialize(user, cep)
    @user = user
    @cep = cep
  end

  def lookup
    via_cep_address = cache_fetch(cep) { fetch_address }

    handle_address_response(via_cep_address)

    create_or_update_address(via_cep_address)
  rescue StandardError => e
    Rails.logger.error "Failed to create or update address: #{e.message}"
    raise
  end

  private

  def create_or_update_address(via_cep_address)
    Api::AddressCreatorService.new(user, via_cep_address).create_or_update_address
  end

  def fetch_address
    uri = URI.parse("#{VIA_CEP_URL}/#{cep}/json")
    response = Net::HTTP.get_response(uri)

    unless response.is_a?(Net::HTTPSuccess)
      raise StandardError, "Failed to fetch address for CEP #{cep}: #{response.message}"
    end

    JSON.parse(response.body)
  rescue JSON::ParserError => e
    raise StandardError, "Failed to fetch address for CEP: #{e.message}"
  end

  def handle_address_response(address)
    return unless address['erro']

    raise StandardError, "CEP #{cep} not found or invalid"
  end

  def cache_fetch(key)
    Rails.cache.fetch(cache_key(key), expires_in: CACHE_EXPIRATION) do
      address = Concurrent::Future.execute { fetch_address }
      address.value
    end
  end

  def cache_key(key)
    "address_lookup:#{key}"
  end
end
