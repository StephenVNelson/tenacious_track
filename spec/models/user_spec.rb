require 'rails_helper'

RSpec.describe User, type: :model do

  describe "validations" do
    it "has a valid factory" do
      user = FactoryBot.create(:user)
      expect(user).to be_valid
    end
    
    it "is invalid without name" do
      user = FactoryBot.build(:user, name: "       ")
      user.valid?
      expect(user.errors[:name]).to include("can't be blank")
    end

    it "is invalid name over 50 characters" do
      user = FactoryBot.build(:user, name: "#{'a'*51}")
      user.valid?
      expect(user.errors[:name]).to include("is too long (maximum is 50 characters)")
    end

    it "is invalid without email" do
      user = FactoryBot.build(:user, email: "       ")
      user.valid?
      expect(user.errors[:email]).to include("is invalid")
    end

    it "is invalid with email over 250 characters" do
      user = FactoryBot.build(:user, email: "#{'a'*250}@example.com")
      user.valid?
      expect(user.errors[:email]).to include("is too long (maximum is 250 characters)")
    end

    it "should be a valid email format" do
      valid_addresses = %w[user@example.com USER@foo.COM A_US-ER@foo.bar.org
        first.last@foo.jp alice+bob@baz.cn]
        valid_addresses.each do |valid_address|
          user = FactoryBot.build(:user, email: valid_address)
          expect(user).to be_valid
        end
      end

    it "should be an invalid email format" do
      invalid_addresses = %w(user@example,com user_at_foo.org user.name@example. foo@bar_baz.com foo@bar+baz.com)
      invalid_addresses.each do |invalid_address|
        user = FactoryBot.build(:user, email: invalid_address)
        user.valid?
        expect(user.errors[:email]).to include("is invalid")
      end
    end

    it "should a unique email" do
      user = FactoryBot.create(:user, email: 'StephenVNelson@gamil.com')
      duplicate = FactoryBot.build(:user, user.attributes)
      duplicate.valid?
      expect(duplicate.errors[:email]).to include("has already been taken")
    end

    it "should have password present (non blank)" do
      user = FactoryBot.build(:user, password: " "*6)
      user.valid?
      expect(user.errors[:password]).to include("can't be blank")
    end

    it "should have a minimum length for the password" do
      user = FactoryBot.build(:user, password: "a"*5)
      user.valid?
      expect(user.errors[:password]).to include("is too short (minimum is 6 characters)")
    end

    it "authenticated? should return false for a user with nil digest" do
      user = FactoryBot.build(:user)
      expect(user.authenticated?(:remember, '')).to be_falsy
    end
  end

end
