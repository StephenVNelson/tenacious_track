class Exercise < ApplicationRecord
  has_many :exercise_elements
  has_many :elements, through: :exercise_elements

  accepts_nested_attributes_for :exercise_elements

  # validates :series_name, presence: true
  # validates :name, presence: true
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
