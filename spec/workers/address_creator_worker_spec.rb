# spec/workers/address_creator_worker_spec.rb
require 'rails_helper'
require 'sidekiq/testing'

RSpec.describe AddressCreatorWorker, type: :worker do
  describe '#perform' do
    let(:user) { create(:user) }
    let(:user_id) { user.id }
    let(:cep) { '12345678' }

    it 'calls the AddressCreatorService and creates or updates the address' do
      address_creator_service = instance_double('Api::AddressCreatorService')
      allow(Api::AddressCreatorService).to receive(:new).and_return(address_creator_service)

      expect(address_creator_service).to receive(:create_or_update_address)

      AddressCreatorWorker.new.perform(user_id, cep)
    end

    it 'enqueues the job' do
      Sidekiq::Testing.fake! do
        expect {
          AddressCreatorWorker.perform_async(user_id, cep)
        }.to change { Sidekiq::Queues["default"].size }.by(1)
      end
    end

    it 'performs the job successfully' do
      expect {
        AddressCreatorWorker.new.perform(user_id, cep)
      }.not_to raise_error
    end

    it 'raises an error if AddressCreatorService fails' do
      allow(Api::AddressCreatorService).to receive(:new).and_raise(StandardError.new('Failed to create or update address'))

      expect {
        AddressCreatorWorker.new.perform(user_id, cep)
      }.to raise_error(StandardError, 'Failed to create or update address')
    end
  end
end
