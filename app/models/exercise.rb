class Exercise < ApplicationRecord
  has_many :exercise_elements, dependent: :destroy
  has_many :elements, through: :exercise_elements
  accepts_nested_attributes_for :exercise_elements, allow_destroy: true

  validates_with MeasurementValidator

  def self.with_elements(element_name)
    Exercise.joins(:elements).where(:elements => {name: element_name})
  end

  def self.booleans
    booleans = Exercise.columns_hash.select {|k,v| v.type == :boolean}
    booleans.keys
  end

  #Creates string of element names
  def full_name
    name = ""
    if !elements.empty?
      elements_sorted = elements.sort_by {|object| object.element_category.sort}
      elements_sorted.each_with_index do |element, idx|
        name << " " unless idx == 0
        name << "#{element.name}"
      end
      name
    else
      "(no elements for this exercise)"
    end
  end
end
