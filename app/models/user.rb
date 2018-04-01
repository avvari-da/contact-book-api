class User < ApplicationRecord
  # model association
  has_many :contacts, dependent: :destroy

  # validations
  validates_presence_of :name, :email, :password
end
