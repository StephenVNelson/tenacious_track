require 'rails_helper'

RSpec.describe Workout, type: :model do
  describe "validations" do
    it "has a working factory" do
      workout = FactoryBot.create(:workout)
      expect(workout).to be_valid
    end
  end

  describe "methods" do
    it "has a workout .name" do
      workout = FactoryBot.create(:workout,
        client: FactoryBot.create(:client, name: "Chris Farley"),
        phase_number: 1,
        week_number: 1,
        day_number: 1
      )
      expect(workout.name).to eq("Chris Farley – Phase 1, Week 1, Day 1")
    end
  end
end
