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

  scenario "Creates new client and a new workout attached to that client" do
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
    client = Client.first
    client.workouts << FactoryBot.create(:workout,
      client_id: client.id,
      phase_number: 6,
      week_number: 3,
      day_number: 3
    )
    click_link 'New Workout'
    expect(page).to have_current_path("/workouts/new/#{Client.last.id}")
    expect(page).not_to have_text('Phase 2')
    expect(page).not_to have_text('Phase 2')
    select "Phase 6", from: "workout[phase_number]"
    select "Week 2", from: "workout[week_number]"
    select "Day 1", from: "workout[day_number]"
    click_button "Create Workout"
    expect(page).to have_current_path("/workouts/apply-template/#{Workout.last.id}")
    expect(page).to have_text("Workout created. Now pick a template to start with.")
    click_link("blank-template")
    expect(page).to have_current_path("/workouts/#{Workout.last.id}")
    expect(page).to have_text("Roger Rabbit – Phase 6, Week 2, Day 1")
  end
end
