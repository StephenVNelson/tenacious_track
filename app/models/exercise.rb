class Exercise < ApplicationRecord
  include PgSearch

  has_many :exercise_elements, dependent: :destroy
  has_many :elements, through: :exercise_elements
  accepts_nested_attributes_for :exercise_elements, allow_destroy: true, reject_if: :unique_element_combo
  validates_with MeasurementValidator
  # validates_associated :exercise_elements
  # validate :element_uniqueness, if: :elements_unique?, on: :update
  # validate :unique_element_combo

  pg_search_scope :search_by_exercise_reps_bool,
    using: {
        :tsearch => {:dictionary => "simple"}
      },
    associated_against: {
      elements: :name
    }

  def self.element_search(query)
    # binding.pry
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

  # def elements_unique?
  #   all_exercises_but_self = Exercise.where.not(id: self.id)
  #   all_exercises = all_exercises_but_self.map(&:elements)
  #   all_sorted = all_exercises.each.sort
  #   this_exercise = self.elements.sort
  #   all_sorted.include?(this_exercise) ? true : false
  # end
  #
  # #validate unique exercise
  # def element_uniqueness
  #   if elements_unique?
  #     self.errors[:base] << "Exercise already exists, consider adding different elements"
  #   end
  # end

  def unique_element_combo(attributes)
    binding.pry
    Exercise.all.each do |e|
      # binding.pry if Exercise.count >= 2 && self == Exercise.first
      if (e.elements.ids - self.elements.ids).empty?
        errors.add(:exercises, :uniqueness)
      end
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

# DONE: Figure out what you want to do about duplicate exercises id:6
