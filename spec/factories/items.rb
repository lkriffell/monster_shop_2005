FactoryBot.define do
  factory :item do
    name { Faker::Games::Zelda.item }
    description { Faker::TvShows::MichaelScott.quote }
    price { Faker::Number.number(digits: 2) }
    image { Faker::Avatar.image }
    inventory { Faker::Number.number(digits: 2) }
    #association :merchant
  end
end
