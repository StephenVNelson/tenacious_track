class Exercise < ApplicationRecord
  include PgSearch

  has_many :exercise_elements, dependent: :destroy
  has_many :elements, through: :exercise_elements#, after_add: :track_added, after_remove: :track_removed
  accepts_nested_attributes_for :exercise_elements, allow_destroy: true
  validates_with MeasurementValidator
  before_save :record_elements
  #create
    # add if save and custom "validation" which check uniqueness to the save
    # if it doesn't pass uniqueness delete all of the associations and add an error to the build.
  #update
    # have a before save action that clears the class variables that keep track of what was added or destroyed
    # create before add and before destroy actions that keep track of what was added and destroyed
    # add to controller update action if save and custom validation which check for uniqueness
    # uniqueness checker will check to see if the set already exists, if it does then it will delete the added and add the deleted and add an error to the base of the object

  @@elements_before_save = []

  def record_elements
    @@elements_before_save.clear
    # binding.pry unless ExerciseElement.count < 6
    @@elements_before_save.concat(elements)
  end


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
    array = self.elements.map(&:name)
    array.sort
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


  def is_not_unique?
    elements.reload
    sorted_exercises = Exercise.where.not(id: self.id).map {|e| e.element_ids.sort}
    sorted_exercises.include?(self.element_ids.sort)
  end

  def abort_creation
    self.destroy
  end

  def abort_update
    self.elements.clear
    # binding.pry
    self.elements.concat(@@elements_before_save)
    self.elements.reload
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

# DONE: Figure out what you want to do about duplicate exercises id:6
