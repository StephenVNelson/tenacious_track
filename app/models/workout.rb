class Workout < ApplicationRecord
  belongs_to :trainer, class_name: "User"
  belongs_to :client

  def name
    "#{client.name} – Phase #{phase_number}, Week #{week_number}, Day #{day_number}"
  end

  def self.select_arrays(client, option)
    option = option.titleize
    if option == 'Phase'
      last_phase = client.workouts.sort_by {|workout| workout.phase_number}.max
      min = last_phase.nil? ? 1 : last_phase.phase_number
      max = min + 4
      (min..max).map {|n| ["#{option} #{n}", n.to_s]}
    elsif option == 'Week'
      last_week = client.workouts.sort_by {|workout| workout.week_number}.max
      min = last_week.nil? ? 1 : last_week.week_number
      order = [1,2,3,4]
      order = (order << order.shift(min-1)).flatten
      order.map {|n| ["#{option} #{n}", n.to_s]}
    elsif option == 'Day'
      (1..7).map {|n| ["#{option} #{n}", n.to_s]}
    else []
    end
  end
end
