FactoryBot.define do
  factory :workout do
    trainer
    client
    sequence :scheduled_date do |n|
      Date.new(2019,2,5).days_ago(365-(3*n))
    end
    # scheduled_date { "2019-01-24" }
    # logged_date { "2019-01-24 17:18:47" }
    sequence :logged_date do |n|
      Date.new(2019,2,5).days_ago(365-(3*n))
    end
    sequence(:phase_number) { |n| (n/4)+1 }
    sequence(:week_number) { |n| ((n/2)%4)+1 }
    sequence(:day_number) { |n| (n%2)+1 }
    workout_focus { "MyString" }
  end
end
