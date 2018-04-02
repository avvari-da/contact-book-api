require 'rails_helper'

RSpec.describe User, type: :model do
  # Association test
  # ensure User model has a 1:m relationship with the Contact model
  it do
    should have_many(:contacts).dependent(:destroy)
  end
  # ensure User model has a 1:m relationship with the UserToken model
  it do
    should have_many(:user_tokens).dependent(:destroy)
  end

  # Validation test
  # ensure column name, email & password are present before saving
  it do
    should validate_presence_of(:name)
  end
  it do
    should validate_presence_of(:email)
    should validate_uniqueness_of(:email)
  end
  it do
    should validate_presence_of(:password)
  end
end
