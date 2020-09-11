class User < ApplicationRecord
  validates :email, uniqueness: true, presence: true
  validates_presence_of :address, :city, :state, :zip, :password, :name


  has_secure_password

  # enum role: %w(default admin merchant)
  enum role: ['default', 'admin', 'merchant']
end
