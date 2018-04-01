require 'rails_helper'

RSpec.describe Contact, type: :model do
  # Association test
  # ensure Contact model has a 1:1 relationship with the User model
  it do
    should belong_to(:user)
  end

  # Validation tests
  # ensure columns firstname, lastname & email are present before saving
  it do
    should validate_presence_of(:firstname)
  end
  it do
    should validate_presence_of(:lastname)
  end
  it do
    should validate_presence_of(:email)
  end
end
