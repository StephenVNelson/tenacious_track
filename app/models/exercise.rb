class Exercise < ApplicationRecord
  has_many :exercise_elements
  has_many :elements, through: :exercise_elements


  #Creates string of element names
  def name
    name = ""
    if !elements.empty?
      elements.each do |element|
        name << " #{element.name}"
      end
      name
    else
      "(no elements for this exercise)"
    end
  end
end
