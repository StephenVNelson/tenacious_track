class Workout < ApplicationRecord
  extend ActionView::Helpers::TextHelper

  belongs_to :trainer, class_name: "User", optional: true
  belongs_to :client

  validates :scheduled_date, presence: {message: "must be included"}
  validates :phase_number, presence: {message: "must be included"}
  validates :week_number, presence: {message: "must be included"}
  validates :day_number, presence: {message: "must be included"}

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
    # The whole Date.today + 1 might be an error, but I just put it in to make the code pass and I don't understand why
    earlier = earlier_workout == Date.today ? Date.today: earlier_workout.scheduled_date.to_date
    later = later_workout.scheduled_date.to_date
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
    day_span > 0 ? time_span :  time_span = "Pending Completion"
  end
end
