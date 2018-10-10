class Exercise < ApplicationRecord
  has_many :exercise_elements
  has_many :elements, through: :exercise_elements
  accepts_nested_attributes_for :exercise_elements

  validate :measurement_presence

  def measurement_presence
    accept_array = [reps_bool , right_left_bool , resistance_bool , duration_bool , work_rest_bool]
    if accept_array.all?{|attr| attr.nil?}
      errors.add("You", "must select a measurement method")
    end
  end

  def self.with_elements(element_name)
    Exercise.joins(:elements).where(:elements => {name: element_name})
  end

  #Creates string of element names
  def full_name
    name = ""
    if !elements.empty?
      elements.each_with_index do |element, idx|
        name << " " unless idx == 0
        name << "#{element.name}"
      end
      name
    else
      "(no elements for this exercise)"
    end
  end
end
