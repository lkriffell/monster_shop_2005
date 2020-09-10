class User < ApplicationRecord
  validates :username, uniqueness: true, presence: true
  validates :email, uniqueness: true, presence: true
  validates_presence_of :address, :city, :state, :zip
  validates_presence_of :password


  has_secure_password
end
