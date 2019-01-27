FactoryBot.define do
  factory :execution do
    exercise
    workout
    sets { rand(1..3) }
    reps { [10, 15, 20].sample }
    resistance { %w(red green blue).sample }
    seconds { [nil, nil, nil, nil, 1].sample }
  end
end
