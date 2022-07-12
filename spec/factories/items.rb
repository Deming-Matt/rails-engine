FactoryBot.define do
  factory :item do
    name { Faker::Movie.title }
    description { Faker::Movie.quote }
    unit_price { Faker::Number.within(range: 1..10) }
  end
end
