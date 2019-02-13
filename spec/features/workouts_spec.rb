require 'rails_helper'

RSpec.feature "Workouts", type: :feature do
  before(:context) do
    @user = FactoryBot.create(:admin)
    login @user
  end

  scenario "it restructs access to trainers" # TODO: build test for restricting workouts to trainers

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
    client = create(:client)
    # visit '/workouts'
    # click_link 'New Workout'
    # click_link "#{client.name}"
    # click_button "Create Workout"
    # click_button "Blank Template"
    workout = FactoryBot.create(:workout, client: client)
    visit "/workouts/#{workout.id}"
    expect {
      find("#add_template").click
      fill_in("new-category", with: "Movement Prep")
      click_button("Create Category")
    }.to change{Execution.count}.by(1)
  end
end
