require 'rails_helper'


RSpec.describe ExecutionCategory, type: :model do
  it "has a working factory" do
    execution_category = FactoryBot.create(:execution_category)
    expect(execution_category).to be_valid
  end

  describe "Validations" do
    it "Is invalid without a name" do
      execution_category = build(:execution_category, name: nil)
      execution_category.valid?
      expect(execution_category.errors[:name]).to include("can't be blank")
    end

    it "Is invalid if not unique" do
      execution_category = FactoryBot.create(:execution_category, name: "Movement Prep")
      copy = ExecutionCategory.new(execution_category.attributes)
      copy.valid?
      expect(copy.errors[:name]).to include("has already been taken")
    end

    it "Has an all lowercase name" do
      execution_category = FactoryBot.create(:execution_category, name: "Movement Prep")
      expect(execution_category.name).to eq("movement prep")
    end
  end

  describe "Associations" do
    it "associates with executions" do
      execution_category = FactoryBot.create(:execution_category)
      execution = FactoryBot.create(:execution, execution_category: execution_category)
      expect(execution_category.executions).to include(execution)
    end
  end
end
