FactoryBot.define do
  factory :shopper do
    sequence(:name) { |i| "name#{i}" }
    sequence(:email) { |i| "email#{i}@email.com" }
    sequence(:nif) { |i| "0000000#{i}" }
  end
end
