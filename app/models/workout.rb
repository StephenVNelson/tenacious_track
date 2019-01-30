class Workout < ApplicationRecord
  belongs_to :trainer, class_name: "User"
  belongs_to :client

  def name
    "#{client.name} – Phase #{phase_number}, Week #{week_number}, Day #{day_number}"
  end
end
