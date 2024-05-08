class Address < ApplicationRecord
  belongs_to :user

  validates :cep, presence: true
end
