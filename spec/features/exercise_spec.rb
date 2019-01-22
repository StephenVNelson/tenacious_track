require 'rails_helper'

RSpec.feature "Exercises", type: :feature do
  context "As Admin" do
    before(:example) do
      @exercise_1 = FactoryBot.create(:exercise, :with_3_elements)
      @exercise_2 = FactoryBot.create(:exercise, :with_3_elements)
      @exercise_1.reload
      @exercise_2.reload
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

    scenario "Deletes exercises that are not unique", js:true do
      visit exercises_path
      expect{
        form = "exercise[exercise_elements_attributes][0][element_id][]"
        find('#add-element', :text => 'Quick add exercise').click
        select "#{@exercise_1.elements.first.name}", from: form
        select "#{@exercise_1.elements.second.name}", from: form
        select "#{@exercise_1.elements.third.name}", from: form
        find("#reps_bool").click
        click_button "Create"
        expect(page).to have_current_path(exercises_path)
        expect(page).to have_text("Exercise did not save because an identical exercise already exists.")
      }.to change(Exercise, :count).by(0)
    end

    scenario "Undoes saved changes on update if exercise is not unique", js:true do
      visit exercises_path
      click_link "edit_#{@exercise_1.id}"
      find("##{ElementCategory.third.category_name.downcase}").click
      find("##{ElementCategory.fourth.category_name.downcase}").click
      find("##{ElementCategory.offset(5).limit(1)[0].category_name.downcase}").click
      find("#first_element").click
      find("##{Element.first.name}").click
      find("##{Element.second.name}").click
      find("##{Element.third.name}").click
      find("##{Element.fourth.name}").click
      find("#second_element").click
      click_button "Submit"
      expect(@exercise_1.elements.reload).to eq([
        Element.find_by(name: "#{Element.first.name}"),
        Element.find_by(name: "#{Element.second.name}"),
        Element.find_by(name: "First element")
        ])
      expect(page).to have_current_path(exercises_path)
      expect(page).to have_text("Edits did not save because an identical exercise already exists.")
      expect(page).not_to have_text("Exercise was successfully updated.")
    end

    scenario "Creates new exercise", js: true  do
      visit exercises_path
      expect(page).to have_current_path("/exercises")
      expect{
        click_button "Create new exercise"
        find("##{ElementCategory.first.category_name.downcase}").click
        find("##{Element.first.name}").click
        find("##{ElementCategory.second.category_name.downcase}").click
        find("##{Element.second.name}").click
        find("#reps_bool").click
        click_button "Submit"
      }.to change(Exercise, :count).by(1)
      expect(page).to have_text("Exercise was successfully created.")
    end

    scenario "Edits new exercise", js: true do
      visit exercises_path
      expect{
        first(:css, 'i.fas.fa-edit').click
        expect(page).to have_current_path("/exercises/#{@exercise_1.id}/edit")
        find("##{Element.first.name}").click
        find("##{Element.second.name}").click
        click_button "Submit"
        @exercise_1.reload
      }.to change(@exercise_1, :full_name).from("#{Element.first.name} #{Element.second.name} First element").to("First element")
    end
  end

  scenario "Limits access for trainers" do
    @exercise_1 = FactoryBot.create(:exercise)
    trainer = FactoryBot.create(:user)
    login trainer
    expect(page).not_to have_css("i.fas.fa-edit")
    expect(page).not_to have_link("Create new exercise")
  end
end
