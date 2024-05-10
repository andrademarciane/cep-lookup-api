class AddressCreatorWorker
  include Sidekiq::Worker

  def perform(user_id, cep)
    Api::AddressCreatorService.new(user_id, cep).create_or_update_address
  end
end