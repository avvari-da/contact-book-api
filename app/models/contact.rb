class Contact < ApplicationRecord
  # model association
  belongs_to :user

  # validations
  validates_presence_of :firstname, :lastname, :email
end
