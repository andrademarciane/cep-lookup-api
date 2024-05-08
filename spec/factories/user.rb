FactoryBot.define do
  factory :user do
    email { 'user.api@example.com' }
    password { 'password123' }
  end
end