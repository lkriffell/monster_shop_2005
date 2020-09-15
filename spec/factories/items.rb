FactoryBot.define do
  factory :item do
    name { Faker::Games::Zelda.item }
    description { Faker::Quotes::Chiquito.sentence }
    price { Faker::Number.number(digits: 3) }
    image { Faker::Avatar.image }
    inventory { Faker::Number.number(digits: 4) }
    #association :merchant
  end
end
