class Element < ApplicationRecord
  include PgSearch

  belongs_to :element_category
  has_many :exercise_elements
  has_many :exercises, through: :exercise_elements

  validates :name, presence: true, length: {maximum: 50}, uniqueness: { case_sensitive: false }
  validates :element_category_id, presence: true

  pg_search_scope :search_by_element_name, :against => :name,
    using: {tsearch: {dictionary: "english", prefix: true, any_word: true}},
    associated_against: {element_category: :category_name}

  def self.text_search(query)
    if query.present?
      search_by_element_name(query)
    else
      Element.all.sort_by {|object| object.element_category.sort}
    end
  end

  def self.names
    Element.all.map(&:name)
  end

  def self.by_name(element_name)
    Element.find_by(name: element_name)
  end

  def self.sorted_categories
    ElementCategory.all.sort_by {|p| p.sort}
  end

  def self.category_list
    Element.sorted_categories.map(&:category_name)
  end

  def self.category_elements(category_name)
    ElementCategory.find_by(category_name: category_name).elements
  end

  def self.category_element_names(category_name)
    element_objects = Element.category_elements(category_name)
    element_objects.map(&:name)
  end

  def self.category_element_names_and_ids(category_name)
    element_names = Element.category_elements(category_name)
    element_names.map {|element| [element.name , element.id]}
  end

  def self.element_names_and_ids_grouped_by_categories
    categories = Element.category_list
    categories.map {|category| [category, Element.category_element_names_and_ids(category)]}
  end

  def self.element_names_grouped_by_categories
    categories = Element.category_list
    categories.map {|category| [category, Element.category_element_names(category)]}
  end

end
