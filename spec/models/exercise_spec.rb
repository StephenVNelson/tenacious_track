require 'rails_helper'
require 'pry'

RSpec.describe Exercise, type: :model do

  it "has a working factory" do
    exercise = build(:exercise)
    expect(exercise).to be_valid
  end

  it "has associated element" do
    exercise = create(:exercise_with_element)
    expect(exercise.elements.count).to eq(1)
  end

  it "is invalid without at least one measurement" do
    exercise = build(:exercise,
      reps_bool: false,
      resistance_bool: false,
      duration_bool: false,
      work_rest_bool: false
    )
    exercise.valid?
    expect(exercise.errors[:measurements]).to include("At least one measurement must be selected")
  end

  #TODO: Update this to not use .is_not_unique
  it "is_not_unique?" do
    exercise1 = FactoryBot.create(:exercise, :with_3_elements)
    exercise2 = FactoryBot.create(:exercise)
    Element.all.each {|e| exercise2.elements << e}
    expect(exercise1.elements.reload).to eq(exercise2.elements)
    expect(exercise2.is_not_unique?).to be_truthy
  end



  describe 'Working with elements' do
    before(:context) do
      @element1 = create(:element_angle, name: "first element")
      @element2 = create(:element_angle, name: "second element")
      @element3 = create(:element_body_position, name: "third element")
      @exercise1 = create(:exercise)
      @exercise1.elements.concat([ @element1, @element2 ])
      @exercise2 = create(:exercise)
      @exercise2.elements.concat([ @element3, @element2 ])
    end
    after(:context) do
      [Element,ElementCategory,Exercise,ExerciseElement].each do |c|
        c.delete_all
      end
    end

    it "Returns String of all associated element names as exercise #name" do
      exercise_name = @exercise1.name
      expect(exercise_name).to eq("First Element Second Element")
    end

    it "updates #name whenever associations are added or edited" do
      element = create(:element_body_position, name: "new name" )
      expect(@exercise1.name).to eq("First Element, Second Element")
      @exercise1.elements << element
      expect(@exercise1.name).to eq("First Element, Second Element, New Name")
      @exercise1.elements.delete(*[@element1, element])
      expect(@exercise1.name).to eq("Second Element")
    end


    it "Returns only exercises with .elements_search" do
      expect(Exercise.element_search("Second")).to include(@exercise1, @exercise2)
      expect(Exercise.element_search("First")).not_to include(@exercise2)
      expect(Exercise.element_search("First")).to include(@exercise1)
    end

    it "Returns sorted exercises if no query" do
      expect(Exercise.element_search("")).to eq([@exercise1,@exercise2])
    end

    it "Returns exercises .with_elements" do
      search1 = Exercise.with_elements("Third Element")
      expect(search1).to eq([@exercise2])
    end

    it "Returns an exercise's #elements_names" do
      elements = @exercise1.elements_names
      expect(elements).to eq(["First Element", "Second Element"])
    end

    describe "categories and elements" do
      it "Returns hash with #category_element_association_count" do
        cat_ele = @exercise1.category_element_association_count
        hash = {"Body Position" => 0, "Angle" => 2}
        expect(cat_ele).to eq(hash)
      end
    end

  end

  describe "Working with attributes" do
    it "Returns .booleans for Exercise" do
      booleans = Exercise.booleans
      expect(booleans).to eq(["reps_bool", "resistance_bool", "duration_bool", "work_rest_bool"])
    end

    it "Returns .bool_humanize" do
      booleans = Exercise.bool_humanize("reps_bool")
      expect(booleans).to eq("Reps ")
    end

  end


end
