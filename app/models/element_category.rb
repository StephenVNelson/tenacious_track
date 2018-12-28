class ElementCategory < ApplicationRecord
  include RailsSortable::Model
  set_sortable :sort  # Indicate a sort column

  has_many :elements

  validates :category_name, presence: true, uniqueness: { case_sensitive: false }, length: {maximum: 50}
  validates :sort, presence: true #, uniqueness: true

  def self.by_position
    order(:sort).all
  end

  def self.max_position
    ElementCategory.maximum(:sort) ? ElementCategory.maximum(:sort) + 1 : 1
  end
end
