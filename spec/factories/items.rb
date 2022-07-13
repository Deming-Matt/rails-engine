FactoryBot.define do
  factory :item do
    name { Faker::Movie.title }
    description { Faker::Movie.quote }
    unit_price { Faker::Number.decimal(r_digits: 2) }
  end
end
