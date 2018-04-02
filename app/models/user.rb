class User < ApplicationRecord
  # model association
  has_many :contacts, dependent: :destroy
  has_many :user_tokens, dependent: :destroy

  # validations
  validates_presence_of :name, :password
  validates :email, presence: true, uniqueness: true

  def get_user_latest_active_access_token
    self.user_tokens.where(active: true).try(:last).access_token
  end
end
