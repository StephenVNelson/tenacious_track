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


  def self.by_name(element_name)
    Element.find_by(name: element_name)
  end

  def self.series_list
    Element.distinct.pluck(:series_name)
  end

  def self.series_list_items(series_name)
    Element.where(series_name: series_name)
  end
end
