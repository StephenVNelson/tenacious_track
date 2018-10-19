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

  def self.series_list
    Element.distinct.pluck(:series_name)
  end

  def self.series_list_items(series_name)
    Element.where(series_name: series_name)
  end

  def self.elements_of_category(category)
    category_id = ElementCategory.find_by(category_name: category).id
    element_array = Element.all.where(element_category_id: category_id)
    name_array = element_array.map(&:name)
    blank_array = []
    name_array.each do |name|
      blank_array. << [name, {class: 'select-element'}]
    end
    blank_array
  end

  def self.categories_and_elements
    categories = ElementCategory.all.map(&:category_name)
    options = []
    categories.each do |category|
      options.concat(Element.elements_of_category(category).prepend([category, {class: 'select-category'}]))
    end
    options
  end

end
