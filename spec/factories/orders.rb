FactoryBot.define do
  factory :order do
    name { Faker::Games::Pokemon.name }
    address { Faker::Address.street_address }
    city { Faker::Address.city }
    state { Faker::Address.state_abbr }
    zip { Faker::Address.zip }
    status { 0 }
  end
end
