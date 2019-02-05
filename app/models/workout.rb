class Workout < ApplicationRecord
  extend ActionView::Helpers::TextHelper

  belongs_to :trainer, class_name: "User"
  belongs_to :client

  def name
    "#{client.name} – Phase #{phase_number}, Week #{week_number}, Day #{day_number}"
  end

  def self.phase_week_day_form_selectors(client, option)
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

  def self.time_span_between(later_workout, earlier_workout = Date.today)
    earlier = earlier_workout == Date.today ? Date.today : earlier_workout.logged_date.to_date
    later = later_workout.logged_date.to_date
    day_span = (earlier - later).to_i
    months = day_span / 30
    weeks = (day_span % 30) / 7
    days = (day_span % 30) % 7
    time_span = ""
    if months > 0
      time_span += "#{pluralize(months, 'Month')}"
      time_span += ", " if weeks > 0
    end
    if weeks > 0
      time_span += "#{pluralize(weeks, 'Week')}"
      time_span += ", " if days > 0
    end
    if days > 0
      time_span += "#{pluralize(days, 'Day')}"
    end
    time_span += "."
  end

  def last_logged_workouts(amount = 3)
    Workout.where(client_id: client.id).order(logged_date: :asc).last(amount)
  end

  def last_workouts_and_timespans_hash(amount = 3)
    workouts_and_timespans = {workouts: [], timespans: []}
    last_logged_workouts(amount).each_with_index do |workout, idx|
      if idx != last_logged_workouts.length - 1
        timespan = Workout.time_span_between(workout, last_logged_workouts(amount)[idx + 1])
      else
        timespan = Workout.time_span_between(workout)

      end
      workouts_and_timespans[:workouts] << workout
      workouts_and_timespans[:timespans] << timespan
    end
    workouts_and_timespans
  end
end
