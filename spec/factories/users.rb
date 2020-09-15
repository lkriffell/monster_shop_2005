FactoryBot.define do
  factory :user do
    name { Faker::TvShows::GameOfThrones.character }
    address { Faker::Address.street_address }
    city { Faker::Address.city }
    state { Faker::Address.state_abbr }
    zip { Faker::Address.zip }
    email { Faker::Internet.free_email(name: name) }
    password { "password" }

    factory :merchant_user do
      # merchant
      role { 1 }
    end

    factory :admin do
      role { 2 }
    end
  end
end
