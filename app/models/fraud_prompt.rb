class FraudPrompt < ApplicationRecord
  belongs_to :user # creates an association with the User model

  # Validations for the columns
  validates :category, presence: true
  validates :user_input, presence: true
  validates :user_input, length: { maximum: 1000, message: "Input is too long" }
end
