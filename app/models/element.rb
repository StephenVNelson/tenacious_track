class Element < ApplicationRecord
  require 'csv'

  has_many :exercise_elements
  has_many :exercises, through: :exercise_elements

  validates :series_name, presence: true, length: {maximum: 50}
  validates :name, presence: true, length: {maximum: 50}, uniqueness: { case_sensitive: false }

  def self.by_name(element_name)
    Element.find_by(name: element_name)
  end

  def self.series_list
    Element.distinct.pluck(:series_name)
  end

  def self.series_list_items(series_name)
    Element.where(series_name: series_name)
  end

  #a class method import, with file passed through as an argument
  def self.import(file)
    # a block that runs through a loop in our CSV data
    CSV.foreach(file.path, headers: true,:encoding => 'ISO-8859-1') do |row|
      #creates an element for each row in the CSV file
      Element.create! row.to_hash
    end
  end
end
