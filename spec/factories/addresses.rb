FactoryBot.define do
  factory :address do
    cep { '12345678' }
    street { 'Rua Teste' }
    neighborhood { 'Bairro Teste' }
    city { 'Cidade Teste' }
    state { 'TS' }
    user { create(:user) }
  end
end
