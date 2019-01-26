require 'rails_helper'

RSpec.describe Workout, type: :model do
  describe "validations" do
    it "has a working factory" do
      workout = FactoryBot.create(:workout)
      expect(workout).to be_valid
    end
  end
end
