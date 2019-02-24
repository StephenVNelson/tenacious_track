require 'rails_helper'

RSpec.describe Execution, type: :model do
  #TODO: 1 add validation for unique category and exercise combination
  describe "validations" do
    it "has a working factory" do
      execution = FactoryBot.create(:execution)
      expect(execution).to be_valid
    end

    it "must have an exercise to be valid" do
      execution = FactoryBot.build(:execution, exercise: nil)
      execution.valid?
      expect(execution.errors[:exercise]).to include("must exist")
    end

    it "must have a workout to be valid" do
      execution = FactoryBot.build(:execution, workout: nil)
      execution.valid?
      expect(execution.errors[:workout]).to include("must exist")
    end

    it "must have an execution_category to be valid" do
      execution = FactoryBot.build(:execution, execution_category: nil)
      execution.valid?
      expect(execution.errors[:execution_category]).to include("must exist")
    end
  end

  describe "associations" do
    it "associates with a workout" do
      workout = FactoryBot.create(:workout)
      execution = FactoryBot.create(:execution, workout_id: workout.id)
      expect(execution.workout).to eq(workout)
    end

    it "associates with an exercise" do
      exercise = FactoryBot.create(:exercise)
      execution = FactoryBot.create(:execution, exercise_id: exercise.id)
      expect(execution.exercise).to eq(exercise)
    end

    it "associates with an execution_category" do
      execution_category = FactoryBot.create(:execution_category)
      execution = FactoryBot.create(:execution, execution_category: execution_category)
      expect(execution.execution_category).to eq(execution_category)
    end
  end
end
