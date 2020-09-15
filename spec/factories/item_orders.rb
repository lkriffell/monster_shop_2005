FactoryBot.define do
  factory :item_order do
    price { Faker::Number.number(digits: 2) }
    quantity { Faker::Number.number(digits: 1) }
  end
end
