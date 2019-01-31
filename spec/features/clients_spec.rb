require 'rails_helper'

RSpec.feature "Clients", type: :feature do
  before(:example) do
    user = FactoryBot.create(:admin)
    login user
  end
  scenario "Cannot acceess unless admin" do
    find('#navbarDropdown').click
    click_link 'Log out'
    visit '/clients'
    expect(page).to have_current_path(login_path)
    non_admin = FactoryBot.create(:user)
    client = FactoryBot.create(:client)
    login non_admin
    visit '/clients'
    expect(page).to have_none_of_selectors("#edit_#{Client.first.id}")
    expect(page).to have_current_path(clients_path)
    visit '/clients/new'
    expect(page).to have_current_path(user_path(non_admin))
  end
  scenario "Creates new client and a new workout attached to that client", js:true do
    visit '/clients'
    expect{
      click_link 'New Client'
      fill_in "client[name]", with: "Roger Rabbit"
      fill_in "client[email]", with: "Roger@rabit.com"
      fill_in "client[phone]", with: "208-891-8492"
      fill_in "client[weekly_commitment]", with: "1"
      click_button "Create Client"
    }.to change{Client.count}.by(1)
    expect(page).to have_current_path("/clients/#{Client.last.id}")
    expect(page).to have_text('Client was successfully created.')
    click_link 'New Workout'
    expect(page).to have_current_path("/workouts/new/#{Client.last.id}")
    # TODO: 3 design a visual helper for the traier to be able to see the Client's workout history
    # TODO: 2 make these tests a little more complicated by adding workouts for this client through FactoryBot before you can select a phase week and day. make sure "out of range numbers are not an option"
    select "Phase 1", from: "workout[phase_number]"
    select "Week 1", from: "workout[week_number]"
    select "Day 1", from: "workout[day_number]"
    click_button "Create Workout"
    expect(page).to have_current_path("/workouts/#{Workout.last.id}")
    expect(page).to have_text("Workout created. Now pick a template to start with.")
    expect(page).to have_text("Roger Rabbit – Phase 1, Week 1, Day 1")
    # click_link 'Back'
  end
end
