require 'rails_helper'

RSpec.feature "Exercises", type: :feature do
  context "As Admin" do
    before(:example) do
      @exercise_1 = FactoryBot.create(:exercise, :with_3_elements)
      @exercise_2 = FactoryBot.create(:exercise, :with_3_elements)
      @exercise_1.elements << FactoryBot.create(:element, name: "First element")
      @exercise_2.elements << FactoryBot.create(:element, name: "Second element")
    end

    scenario "logs in a opens the exercises link" do
      user = FactoryBot.create(:admin)
      login user
      click_link "Exercise"
      click_link "Exercises"
      expect(page).to have_current_path("/exercises")
    end

    scenario "Searches exercises" do
      visit exercises_path
      select "First", from: "query"
      click_button "Filter"
      expect(page).to have_text(@exercise_1.full_name.to_s)
      expect(page).not_to have_text(@exercise_2.full_name.to_s)
      click_button "Filter"
      expect(page).to have_text(@exercise_1.full_name.to_s)
      expect(page).to have_text(@exercise_2.full_name.to_s)
    end

    scenario "Quick adds exercise from index page", js: true do
      visit exercises_path
      expect{
        form = "exercise[exercise_elements_attributes][0][element_id][]"
        find('#add-element', :text => 'Quick add exercise').click
        select "First element", from: form
        select "Second element", from: form
        find("#reps_bool").click
        click_button "Create"
        expect(page).to have_current_path(exercises_path)
      }.to change(Exercise, :count).by(1)
    end

    scenario "Creates new exercise", js: true  do
      visit exercises_path
      expect(page).to have_current_path("/exercises/new")
      expect{
        click_button "Create new exercise"
        find("#Category_1").click
        find("#element_1").click
        find("#Category_2").click
        find("#element_2").click
        find("#reps_bool").click
        click_button "Submit"
      }.to change(Exercise, :count).by(1)
      expect(page).to have_text("Exercise was successfully created.")
    end

    scenario "Edits new exercise", js: true do
      visit exercises_path
      sleep 5
      expect{
        first(:css, 'i.fas.fa-edit').click
        expect(page).to have_current_path("/exercises/#{@exercise_1.id}/edit")
        find("#element_1").click
        find("#element_2").click
        click_button "Submit"
      }.to change(@exercise_1, :full_name).from("element_1 element_2 First element").to("First element")
    end

    scenario "Keeps exercises unique", js: true do
      visit exercises_path
      first(:css, 'i.fas.fa-edit').click
      expect(page).to have_current_path("/exercises/#{@exercise_1.id}/edit")
      find("#element_1").click
      find("#element_2").click
      find("#Category_3").click
      find("#Category_4").click
      find("#Category_6").click
      find("#element_3").click
      find("#element_4").click
      find_by_id("First element").click
      find_by_id("Second element").click
      click_button "Submit"

    end

    scenario "Deletes an exercise"
  end

  scenario "Limits access for trainers"
end
