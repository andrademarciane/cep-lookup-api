class Api::AddressesController < Api::ApplicationController
  def show
    address_data = Api::AddressLookupService.new(current_user, params[:cep]).lookup
    serialized_address = Api::AddressSerializer.new(address_data).serialize
    render json: { address: JSON.parse(serialized_address) }, status: :ok
  rescue StandardError => e
    render json: { error: e.message }, status: :unprocessable_entity
  end
end
