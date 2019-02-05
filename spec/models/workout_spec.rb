require 'rails_helper'

RSpec.describe Workout, type: :model do
  describe "validations" do
    it "has a working factory" do
      workout = FactoryBot.create(:workout)
      expect(workout).to be_valid
    end
  end

  describe "methods" do
    it "has a workout .name" do
      workout = FactoryBot.create(:workout,
        client: FactoryBot.create(:client, name: "Chris Farley"),
        phase_number: 1,
        week_number: 1,
        day_number: 1
      )
      expect(workout.name).to eq("Chris Farley – Phase 1, Week 1, Day 1")
    end

    it "returns #phase_week_day_form_selectors of phases prepped for selection" do
      client = FactoryBot.create(:client)
      expect(Workout.phase_week_day_form_selectors(client, 'phase')). to eq([
        ['Phase 1', '1'],
        ['Phase 2', '2'],
        ['Phase 3', '3'],
        ['Phase 4', '4'],
        ['Phase 5', '5']
        ])
      expect(Workout.phase_week_day_form_selectors(client, 'week')).to eq([
        ['Week 1', '1'],
        ['Week 2', '2'],
        ['Week 3', '3'],
        ['Week 4', '4']
        ])
      expect(Workout.phase_week_day_form_selectors(client, 'day')).to eq([
        ['Day 1', '1'],
        ['Day 2', '2'],
        ['Day 3', '3'],
        ['Day 4', '4'],
        ['Day 5', '5'],
        ['Day 6', '6'],
        ['Day 7', '7']
        ])
      client.workouts << FactoryBot.create(:workout,
        phase_number: 8,
        week_number: 4,
        day_number: 6,
      )
      expect(Workout.phase_week_day_form_selectors(client, 'phase')). to eq([
        ['Phase 8', '8'],
        ['Phase 9', '9'],
        ['Phase 10', '10'],
        ['Phase 11', '11'],
        ['Phase 12', '12']
        ])
      expect(Workout.phase_week_day_form_selectors(client, 'week')).to eq([
        ['Week 4', '4'],
        ['Week 1', '1'],
        ['Week 2', '2'],
        ['Week 3', '3']
        ])
      expect(Workout.phase_week_day_form_selectors(client, 'day')).to eq([
        ['Day 1', '1'],
        ['Day 2', '2'],
        ['Day 3', '3'],
        ['Day 4', '4'],
        ['Day 5', '5'],
        ['Day 6', '6'],
        ['Day 7', '7']
        ])
    end

    describe "workout preview methods" do
      before(:example) do
        @client = FactoryBot.create(:client)
        @days_ago = [80,78,68,15,5]
        @days_ago.each do |n|
          FactoryBot.create(:workout,
            client_id: @client.id,
            logged_date: n.days.ago
          )
        end
        @workout = Workout.last
      end

      it "returns #last_logged_workouts" do
        @days_ago.last(3).each_with_index do |n, idx|
          expect(@workout.last_logged_workouts(3)[idx].logged_date.to_date).to eq(n.days.ago.to_date)
        end
      end

      it "returns the .time_span_between" do
        expect(Workout.time_span_between(Workout.third, Workout.fourth)).to eq("1 Month, 3 Weeks, 2 Days.")
        expect(Workout.time_span_between(Workout.first, Workout.second)).to eq("2 Days.")
        expect(Workout.time_span_between(Workout.fourth, Workout.last)).to eq("1 Week, 3 Days.")

      end

      it "returns #last_workouts_and_times_hash" do
        expect(@workout.last_workouts_and_timespans_hash).to eq({
          workouts: [
            Workout.third,
            Workout.fourth,
            Workout.fifth
          ],
          timespans: [
            "1 Month, 3 Weeks, 2 Days.",
            "1 Week, 3 Days.",
            "5 Days."
          ]
        })
      end
    end
  end

  describe "associations" do

  end
end
