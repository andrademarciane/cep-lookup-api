class Api::AddressesController < Api::ApplicationController
  def show
    address_data = Api::AddressLookupService.new(current_user, params[:cep]).lookup
    render json: { address: address_data }, status: :ok
  rescue StandardError => e
    render json: { error: e.message }, status: :unprocessable_entity
  end
end