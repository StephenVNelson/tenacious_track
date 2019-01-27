require 'rails_helper'

RSpec.describe Execution, type: :model do
  describe "validations" do
    it "has a working factory" do
      execution = FactoryBot.create(:execution)
      expect(execution).to be_valid
    end

    it "must have an exercise to be valid" do
      execution = FactoryBot.build(:execution, exercise_id: nil)
      execution.valid?
      expect(execution.errors[:exercise_id]).to include("Execution must include an exericise")
    end

    it "must have a workout to be valid" do
      execution = FactoryBot.build(:execution, workout_id: nil)
      execution.valid?
      expect(execution.errors[:workout_id]).to include("Execution must include a workout")
    end

    it "must"

  end
end
