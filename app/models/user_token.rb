class UserToken < ApplicationRecord
  belongs_to :user
  before_create :generate_access_token

  private

  def generate_access_token
    self.access_token = SecureRandom.uuid.gsub(/\-/,'')
  end
end
