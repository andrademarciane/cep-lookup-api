require 'net/http'
require 'json'
require 'concurrent'

class Api::AddressLookupService
  VIA_CEP_URL = 'https://viacep.com.br/ws'
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

    via_cep_address
  rescue StandardError => e
    Rails.logger.error "Failed to create or update address: #{e.message}"
    raise
  end

  private

  def create_or_update_address(via_cep_address)
    AddressCreatorWorker.perform_async(user.id, via_cep_address)
  end

  def fetch_address
    uri = URI.parse("#{VIA_CEP_URL}/#{cep}/json")
    response = Net::HTTP.get_response(uri)

    handle_failed_response(response) unless response.is_a?(Net::HTTPSuccess)

    JSON.parse(response.body)
  rescue JSON::ParserError => e
    raise StandardError, "Failed to fetch address for CEP: #{e.message}"
  end

  def handle_failed_response(response)
    raise StandardError, "Failed to fetch address for CEP #{cep}: #{response.message}"
  end

  def handle_address_response(address)
    return unless address['erro']

    raise StandardError, "CEP #{cep} not found or invalid"
  end

  def cache_fetch(key, &block)
    Rails.cache.fetch(cache_key(key), expires_in: CACHE_EXPIRATION, &block)
  end

  def cache_key(key)
    "address_lookup:#{key}"
  end
end
