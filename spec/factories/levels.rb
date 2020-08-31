FactoryBot.define do
  factory :level do
    # レベル１はthresholdをゼロにしたい
    sequence(:threshold) { |n| n == 1 ? 0 : n * 10 + 50 }
  end
end
