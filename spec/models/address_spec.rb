require 'rails_helper'

RSpec.describe Address, type: :model do
  # describe 'validations' do
  #   it { should validate_presence_of(:cep) }
  # end
  #
  # describe 'associations' do
  #   it { should belong_to(:user) }
  # end

  describe 'factory' do
    it 'has a valid factory' do
      expect(build(:address)).to be_valid
    end
  end
end