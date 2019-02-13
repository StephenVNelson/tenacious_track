class Exercise < ApplicationRecord
  include PgSearch

  has_many :exercise_elements, dependent: :destroy
  has_many :elements, through: :exercise_elements, after_add: :ass_change_name_update, after_remove: :ass_change_name_update
  accepts_nested_attributes_for :exercise_elements, allow_destroy: true
  validates_with MeasurementValidator
  before_save :record_elements


  @@elements_before_save = []
  def record_elements
    @@elements_before_save.clear
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
      Exercise.all.sort_by {|object| object.current_name}
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
    self.elements.concat(@@elements_before_save)
    self.elements.reload
  end

  def current_name
    self.ass_change_name_update if self.name.nil?
    name
  end

  def ass_change_name_update(*element)
    if !elements.empty?
      elements_sorted = elements.sort_by {|object| object.element_category.sort}
      element_names = elements_sorted.map {|e| e.name.titleize}
      self.name = element_names.join(', ')
    else
      self.name = "(no elements for this exercise)"
    end
  end

  #Creates string of element names
  def full_name(element)
    if !element.empty?
      new_name = []
      element.each do |idx|
        new_name << Element.find(idx).name.titleize
      end
      self.name = new_name.join(', ')
    else
      self.name = "(no elements for this exercise)"
    end
  end
end

# DONE: Figure out what you want to do about duplicate exercises id:6
