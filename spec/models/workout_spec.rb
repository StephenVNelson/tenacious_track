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

    it "returns .select_arrays of phases prepped for selection" do
      client = FactoryBot.create(:client)
      expect(Workout.select_arrays(client, 'phase')). to eq([
        ['Phase 1', '1'],
        ['Phase 2', '2'],
        ['Phase 3', '3'],
        ['Phase 4', '4'],
        ['Phase 5', '5']
        ])
      expect(Workout.select_arrays(client, 'week')).to eq([
        ['Week 1', '1'],
        ['Week 2', '2'],
        ['Week 3', '3'],
        ['Week 4', '4']
        ])
      expect(Workout.select_arrays(client, 'day')).to eq([
        ['Day 1', '1'],
        ['Day 2', '2'],
        ['Day 3', '3'],
        ['Day 4', '4'],
        ['Day 5', '5'],
        ['Day 6', '6'],
        ['Day 7', '7']
        ])
      client.workouts << FactoryBot.create(:workout,
        phase_number: 8,
        week_number: 4,
        day_number: 6,
      )
      expect(Workout.select_arrays(client, 'phase')). to eq([
        ['Phase 8', '8'],
        ['Phase 9', '9'],
        ['Phase 10', '10'],
        ['Phase 11', '11'],
        ['Phase 12', '12']
        ])
      expect(Workout.select_arrays(client, 'week')).to eq([
        ['Week 4', '4'],
        ['Week 1', '1'],
        ['Week 2', '2'],
        ['Week 3', '3']
        ])
      expect(Workout.select_arrays(client, 'day')).to eq([
        ['Day 1', '1'],
        ['Day 2', '2'],
        ['Day 3', '3'],
        ['Day 4', '4'],
        ['Day 5', '5'],
        ['Day 6', '6'],
        ['Day 7', '7']
        ])
    end
  end

  describe "associations" do

  end
end
