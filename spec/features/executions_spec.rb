require 'rails_helper'

RSpec.feature "Executions", type: :feature do
  let(:workout) {create(:workout)}
  let(:exercise) {create(:exercise, :with_3_elements)}

  scenario "working paths that restrict access to trainers" do
    visit "/workouts/#{workout.id}/executions/new"
    expect(page).to have_current_path('/login')
  end

  describe "CRUD actions" do
    before(:example) do
      user = FactoryBot.create(:admin)
      login user
      ["Movement Prep", "Resistance"].each {|r| create(:execution_category,
        name: r
      )}
    end

    scenario "Creates new execution" do
      visit "/workouts/#{workout.id}/executions/new"
      expect(page).to have_current_path("/workouts/#{workout.id}/executions/new")
      expect {
        select "Movement Prep", from: "category_option"
        select "#{exercise.name}", from: "exercise_option"
        click_button "Create Execution"
      }.to change{Execution.count}.by(1)
      expect(page).to have_current_path("/workouts/#{workout.id}")
    end

    # scenario "Edits new execution" do
    #   execution = FactoryBot.create(:execution)
    #   visit "/executions/#{execution.id}/edit"
    #   expect(page).to have_current_path('/executions/new')
    # end
  end

end
