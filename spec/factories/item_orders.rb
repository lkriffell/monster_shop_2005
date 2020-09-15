FactoryBot.define do
  factory :item_order do
    price { Faker::Number.number(digits: 3) }
    quantity { Faker::Number.number(digits: 1) }
  end
end
