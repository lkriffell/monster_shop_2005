FactoryBot.define do
  factory :item_order do
    quantity { Faker::Number.number(digits: 1) }
  end
end
