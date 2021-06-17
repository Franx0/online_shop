FactoryBot.define do
  factory :merchant do
    sequence(:name) { |i| "name#{i}" }
    sequence(:email) { |i| "email#{i}@email.com" }
    sequence(:cif) { |i| "0000000#{i}" }
  end
end
