class ElementCategory < ApplicationRecord
  include RailsSortable::Model
  set_sortable :sort  # Indicate a sort column

  validates :category_name, presence: true, uniqueness: { case_sensitive: false }, length: {maximum: 250}
  validates :sort, presence: true

  def self.by_position
    order(:sort).all
  end

  def self.max_position
    ElementCategory.maximum(:sort)
  end
end
