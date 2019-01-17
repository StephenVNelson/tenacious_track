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

  it "is unique" do
    # TODO: turn on validation and adjust test for validation
    exercise1 = FactoryBot.create(:exercise, :with_3_elements)
    exercise2 = FactoryBot.create(:exercise)
    # expect{
      exercise2.elements.push([Element.first, Element.last])
    # }.to raise_exception(ActiveRecord::RecordInvalid, "Exercise already exists, consider adding different elements")
    # binding.pry

    # exercise1.elements.each do |element|
    #   exercise2.elements << element
    # end
    exercise2.valid?
    expect(exercise2.errors[:base]).to include("Exercise already exists, consider adding different elements")
    expect(exercise1.elements).to eq(exercise2.elements)
    expect(exercise2.element_uniqueness).to eq(["already exists"])
    exercise2.elements.delete(exercise1.elements.first)
    expect(exercise1.elements).not_to eq(exercise2.elements)
    expect(exercise2).to be_valid
    exercise2.elements << exercise1.elements.first
    expect(exercise2.element_uniqueness).to eq(["already exists"])
  end

  describe 'Working with elements' do
    before(:context) do
      @element1 = create(:element_angle, name: "First Element")
      @element2 = create(:element_angle, name: "Second Element")
      @element3 = create(:element_body_position, name: "Third Element")
      @exercise1 = create(:exercise)
      [@element1,@element2].each {|e| @exercise1.elements << e}
      @exercise2 = create(:exercise)
      [@element3,@element2].each {|e| @exercise2.elements << e}

    end
    after(:context) do
      [Element,ElementCategory,Exercise,ExerciseElement].each do |c|
        c.all.each {|e| e.delete}
      end
    end

    it "Is invalid with same elements" do
      exercise1 = create(:exercise)
      exercise2 = build(:exercise)
      [exercise1,exercise2].each do |exercise|
        [@element1, @element2, @element3].each do |element|
          exercise.elements << element
        end
      end
      exercise2.valid?
      expect(exercise2.errors[:exercise]).to include("already exists")
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

      it "Returns String of all associated element names as exercise #full_name" do
        exercise_name = @exercise1.full_name
        expect(exercise_name).to eq("First Element Second Element")
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
