class Client < ApplicationRecord

  before_validation :downcase_email

  validates :name, presence: true
  VALID_PHONE_REGEX = /\A(\+\d{1,2}\s)?\(?\d{3}\)?[\s.-]?\d{3}[\s.-]?\d{4}\z/
  validates :phone, presence: true, format: { with: VALID_PHONE_REGEX}
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: {maximum: 250}, format: {with: VALID_EMAIL_REGEX}, uniqueness: { case_sensitive: false }

  has_many :workouts, dependent: :destroy
  private

    # Converts email to all lower-case.
    def downcase_email
      self.email = email.downcase
    end
end
