class Exercise < ApplicationRecord
  include PgSearch

  has_many :exercise_elements, dependent: :destroy
  has_many :elements, through: :exercise_elements
  accepts_nested_attributes_for :exercise_elements, allow_destroy: true
  validates_with MeasurementValidator
  validate :element_uniqueness

  pg_search_scope :search_by_exercise_reps_bool,
    using: {
        :tsearch => {:dictionary => "simple"}
      },
    associated_against: {
      elements: :name
    }

  def self.element_search(query)
    if query.present?
      search_by_exercise_reps_bool(query)
    else
      Exercise.all.sort_by {|object| object.full_name}
    end
  end


  def self.with_elements(element_name)
    Exercise.joins(:elements).where(:elements => {name: element_name})
  end

  def elements_names
    self.elements.map(&:name)
  end

  def self.booleans
    booleans = Exercise.columns_hash.select {|k,v| v.type == :boolean}
    booleans.keys
  end

  def self.bool_humanize(boolean_name)
    debooled = boolean_name.gsub("bool","")
    debooled.titleize
  end

  #Return a hash with a list of cetegories and whether or not they have more than one element association for a specific exercise
  def category_element_association_count
    category_and_count_hash = {}
    Element.category_list.each {|p| category_and_count_hash[p] = 0}
    self.elements.each do |element|
      category_and_count_hash[element.element_category.category_name] += 1
    end
    category_and_count_hash
  end

  def element_uniqueness
    all_exercises = Exercise.all.map(&:elements_names)
    this_exercise = exercise_elements.map(&:element).map(&:name)
    if all_exercises.include?(this_exercise)
      errors.add(:exercise, "already exists")
    end
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

# DONE:100 Figure out what you want to do about duplicate exercises
