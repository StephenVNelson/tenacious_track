class Element < ApplicationRecord

  belongs_to :element_category
  has_many :exercise_elements
  has_many :exercises, through: :exercise_elements

  validates :name, presence: true, length: {maximum: 50}, uniqueness: { case_sensitive: false }
  validates :element_category_id, presence: true


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
