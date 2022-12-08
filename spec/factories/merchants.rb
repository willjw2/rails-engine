FactoryBot.define do
  factory :merchant do
    name { Faker::Commerce.unique.vendor }
  end
end
