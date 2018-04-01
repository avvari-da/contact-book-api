require 'rails_helper'

RSpec.describe User, type: :model do
  # Association test
  # ensure Contact model has a 1:1 relationship with the User model
  it do
    should have_many(:contacts).dependent(:destroy)
  end

  # Validation test
  # ensure column name, email & password are present before saving
  it do
    should validate_presence_of(:name)
  end
  it do
    should validate_presence_of(:email)
  end
  it do
    should validate_presence_of(:password)
  end
end
