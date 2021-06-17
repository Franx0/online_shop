FactoryBot.define do
  factory :order do
    sequence(:completed_at) { nil }
    amount { 0.0 }
    merchant
    shopper
  end
end
