require 'rails_helper'

RSpec.feature "Workouts", type: :feature do
  # TODO: build test for restricting delete to admin_user
  scenario "it restricts access to trainers" do
    visit '/workouts'
    expect(page).to have_current_path('/login')
  end

  describe "As Admin" do
    before(:example) do
      @user = FactoryBot.create(:admin)
      login @user
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

    scenario "it allows you to create new workout", js:true do
      client = create(:client)
      workout = FactoryBot.create(:workout, client: client)
      visit "/workouts/#{workout.id}"
      expect {
        find("#add_template").click
        fill_in("new-category", with: "Movement Prep")
        click_button("Create Category")
      }.to change{Execution.count}.by(1)
    end
  end

end
