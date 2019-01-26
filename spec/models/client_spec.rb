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

  describe "Associations" do

  end
end
