class User < ApplicationRecord
  validates :email, uniqueness: true, presence: true
  validates :password, confirmation: true, presence: true
  validates_presence_of :address, :city, :state, :zip, :password, :name

  has_secure_password
end
