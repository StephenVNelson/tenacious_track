require 'rails_helper'

RSpec.feature "Workouts", type: :feature do
  before(:context) do
    user = FactoryBot.create(:admin)
    login user
  end
  scenario "it lists all the workouts" do

    6.times do |i|
      FactoryBot.create(:workout,
        client: FactoryBot.create(:client, name: "Client_#{i}"),
        trainer: FactoryBot.create(:trainer, name: "Trainer_#{i}"),
        scheduled_date: Date.today + i
      )
    end
    visit '/workouts'
    expect(page).to have_text("Client_1")
    expect(page).to have_text("Trainer_1")
    click_link "workout_#{Workout.first.id}"
    expect(page).to have_current_path("/workouts/#{Workout.first.id}")
    click_link "Back"
    expect(page).to have_current_path("/workouts")
  end

  scenario "it allows you to create new workout" do
    visit '/workouts'
    click_link 'new_workout'
  end
end
