class User < ApplicationRecord
  validates :email, uniqueness: true, presence: true
  validates_presence_of :address, :city, :state, :zip, :password, :name



  validates :password, confirmation: true
  validates :password, presence: true
  validates :password_confirmation, confirmation: true
  validates :password_confirmation, presence: true

  has_secure_password

  enum role: ['default', 'admin', 'merchant'] 
end
