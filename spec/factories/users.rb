FactoryBot.define do
  factory :user do
    name {}
    address {}
    city {}
    state {}
    zip {}
    email {}
    passord {}

    factory :regular do
      role: 0
    end

    factory :merchant do
      role: 1
      merchant_id
    end

    factory :admin do
      role: 2
    end
  end
end
