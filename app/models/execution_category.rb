class ExecutionCategory < ApplicationRecord
  before_save :downcase_name
  has_many :executions

  validates :name, presence: true, uniqueness: true

  private

  def self.all_names
    ExecutionCategory.all.map {|execution| [execution.name.titleize, execution.id]}
  end

  def downcase_name
    self.name = name.downcase
  end
end
