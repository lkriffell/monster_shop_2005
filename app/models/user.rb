class User < ApplicationRecord
  validates :email, uniqueness: true, presence: true
  validates_presence_of :address, :city, :state, :zip, :password, :name
  validates :password, confirmation: true, presence: true

  has_secure_password
end
