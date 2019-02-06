class Client < ApplicationRecord

  before_validation :downcase_email

  validates :name, presence: true
  VALID_PHONE_REGEX = /\A(\+\d{1,2}\s)?\(?\d{3}\)?[\s.-]?\d{3}[\s.-]?\d{4}\z/
  validates :phone, presence: true, format: { with: VALID_PHONE_REGEX}
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: {maximum: 250}, format: {with: VALID_EMAIL_REGEX}, uniqueness: { case_sensitive: false }

  has_many :workouts, dependent: :destroy


  def last_scheduled_workouts(amount = 3)
    Workout.where(client_id: id).order(scheduled_date: :asc).last(amount)
  end

  def last_workouts_and_timespans_hash(amount = 3)
    workouts_and_timespans = {}

    last_scheduled_workouts(amount).each_with_index do |workout, idx|
      next_workout = last_scheduled_workouts(amount)[idx + 1]
      time_from_today = Workout.time_span_between(workout)
      if next_workout.nil?
        timespan = time_from_today
      else
        time_between_workouts = Workout.time_span_between(workout, next_workout)
        timespan = time_between_workouts
      end
      workouts_and_timespans[workout] = timespan
    end
    workouts_and_timespans
  end

  def nearest_scheduled_workout
    if workouts.count > 0
      workouts.order(:scheduled_date).last.scheduled_date
    else
      Date.today - (365*500)
    end
  end

  def self.order_by_scheduled_workouts
    Client.all.sort_by(&:nearest_scheduled_workout).reverse
  end

  private
    # Converts email to all lower-case.
    def downcase_email
      self.email = email.downcase
    end
end
