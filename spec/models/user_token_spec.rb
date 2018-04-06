require 'rails_helper'

RSpec.describe UserToken, type: :model do
  let!(:user) do
    create(:user)
  end
  it "Create User Token" do
    UserToken.where(user_id: user.id).update(active: false)
    token = UserToken.create!(user: user).access_token
    expect(token).not_to be_empty
  end
end
