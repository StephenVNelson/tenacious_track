require 'rails_helper'

RSpec.describe Client, type: :model do

  describe "Validations" do
    it "has a working factory" do
      client = FactoryBot.build(:client)
      expect(client).to be_valid
    end

    it "Is invalid if name isn't present" do
      client = FactoryBot.build(:client, name: '')
      client.valid?
      expect(client.errors[:name]).to include("can't be blank")
    end

    it "is invalid if email isn't present" do
      client = FactoryBot.build(:client, email: '')
      client.valid?
      expect(client.errors[:email]).to include("can't be blank")
    end

    it "is invalid if email isn't formatted correctly" do
      client = FactoryBot.build(:client, email: 'brokin_email.com')
      client.valid?
      expect(client.errors[:email]).to include('is invalid')
    end

    it "is invalid if email isn't is too long" do
      client = FactoryBot.build(:client, email: "#{'a'*250}@gmail.com")
      client.valid?
      expect(client.errors[:email]).to include('is too long (maximum is 250 characters)')
    end

    it "saves email as without caps" do
      client = FactoryBot.create(:client, email: "HaPPy@gmail.com")
      expect(client.email).to eq('happy@gmail.com')
    end

    it "is invalid if email isn't unique" do
      client = FactoryBot.create(:client, email: "StephenVNelson@gmail.com")
      identical_client = FactoryBot.build(:client, email: "StephenVNelson@gmail.com")
      identical_client.valid?
      expect(identical_client.errors[:email]).to include('has already been taken')
    end

    it "is invalid if phone number isn't present" do
      client = FactoryBot.build(:client, phone: '')
      client.valid?
      expect(client.errors[:phone]).to include("can't be blank")
    end

    it "is valid if phone number is formatted correctly" do
      valid_phones = ["(208) 891-8492", "208 891 8492", "208.891.8492", "208-891-8492", "208.891.8492"]
      valid_phones.each do |phone|
        client = FactoryBot.build(:client, phone: phone)
        expect(client).to be_valid
      end
    end

    it "is invalid if phone number isn't formatted correctly" do
      invalid_phones = ["891-8492", "1-208-891-8492", "208-891-8492 4567"]
      invalid_phones.each do |phone|
        client = FactoryBot.build(:client, phone: phone)
        expect(client).not_to be_valid
      end
    end

  end

  describe "Methods" do
    describe "workout preview methods" do
      before(:example) do
        @client = FactoryBot.create(:client)
        @days_ago = [80,78,68,15,5]
        @days_ago.each do |n|
          FactoryBot.create(:workout,
            client_id: @client.id,
            scheduled_date: n.days.ago
          )
        end
      end

      it "returns #last_scheduled_workouts" do
        @days_ago.last(3).each_with_index do |n, idx|
          expect(@client.last_scheduled_workouts(3)[idx].scheduled_date.to_date).to eq(n.days.ago.to_date)
        end
        Workout.all.each {|w| w.delete}
        expect(Workout.count).to eq(0)
        FactoryBot.create(:workout, client_id: @client.id)
        expect(@client.workouts.count).to eq(1)
        expect(@client.last_scheduled_workouts.length).to eq(1)
      end

      it "returns the .time_span_between" do
        expect(Workout.time_span_between(Workout.third, Workout.fourth)).to eq("1 Month, 3 Weeks, 2 Days.")
        expect(Workout.time_span_between(Workout.first, Workout.second)).to eq("2 Days.")
        expect(Workout.time_span_between(Workout.fourth, Workout.last)).to eq("1 Week, 3 Days.")
        FactoryBot.create(:workout, client_id: @client.id, scheduled_date: 8.days.from_now.to_date)
        expect(Workout.time_span_between(Workout.last)).to eq("Workout pending.")

      end

      it "returns #last_workouts_and_times_hash" do
        expect(@client.last_workouts_and_timespans_hash).to eq({
          Workout.third => "1 Month, 3 Weeks, 2 Days.",
          Workout.fourth => "1 Week, 3 Days.",
          Workout.fifth =>  "5 Days."
        })
        @client.workouts.clear
        expect(@client.workouts).to eq([])
        FactoryBot.create(:workout, client_id: @client.id, scheduled_date: 80.days.ago.to_date)
        expect(@client.last_workouts_and_timespans_hash).to eq({
          Workout.first => "2 Months, 2 Weeks, 6 Days."
        })
      end
    end

    describe "latest client methods" do
      before(:example) do
        3.times {FactoryBot.create(:client)}
        expect(Client.count).to eq(3)
        FactoryBot.create(:workout, scheduled_date: 1.days.ago.to_date, client_id: Client.third.id)
        FactoryBot.create(:workout, scheduled_date: 3.days.ago.to_date, client_id: Client.first.id)
        FactoryBot.create(:workout, scheduled_date: 6.days.ago.to_date, client_id: Client.second.id)

      end

      it "returns the nearest_scheduled_workout for a client" do
        workouts = Client.second.workouts
        nearest_workout = FactoryBot.create(:workout, scheduled_date: 5.days.ago.to_date)
        workouts << nearest_workout
        5.times {|n| workouts << FactoryBot.create(:workout, scheduled_date: (6*(n+1)).days.ago.to_date)}
        expect(Client.second.nearest_scheduled_workout).to eq(nearest_workout.scheduled_date)
      end

      it "returns clients in #order_by_scheduled_workouts" do
        # binding.pry
        expect(Client.order_by_scheduled_workouts).to eq([
          Client.third,
          Client.first,
          Client.second
          ])
      end
    end

  end

  describe "Associations" do
    it "Associates with a workout" do
      client = FactoryBot.create(:client)
      workout = FactoryBot.create(:workout)
      expect{
        client.workouts << Workout.first
      }.to change{client.workouts.count}.from(0).to(1)
    end
  end
  #TODO: create an error for clients if they have a missing workout. like evaluate if the last workout is at phase 5 that they have all the phases previous to 5 etc. same with week and day
end
