FactoryBot.define do
  factory :user do
    name { Faker::Name.name }
    email { Faker::Internet.email }
    password Digest::MD5.hexdigest('test12345')
  end
end