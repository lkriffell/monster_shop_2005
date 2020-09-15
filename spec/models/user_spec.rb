require 'rails_helper'

RSpec.describe User do
  describe "validations" do
      it {should validate_presence_of :name}
      it {should validate_presence_of :address}
      it {should validate_presence_of :city}
      it {should validate_presence_of :state}
      it {should validate_presence_of :zip}
      it {should validate_presence_of :email}
      it {should validate_presence_of :password}

      it {should validate_uniqueness_of :email}

      it {should validate_confirmation_of :password}
  end

  describe "relationships" do
    it { should have_many :orders }
  end

  describe 'roles' do
    it 'can be created as a regular user' do
      user = User.create!(name: "bob", password: '12345', address: "street", city: "Denver", state: "CO", zip:"12345", email: "someone@gmail.com", role: 0)

      expect(user.role).to eq("regular")
      expect(user.regular?).to be_truthy
    end

    it 'can be created as a merchant user' do
      user = User.create!(name: "bob", password: '12345', address: "street", city: "Denver", state: "CO", zip:"12345", email: "someone@gmail.com", role: 1)

      expect(user.role).to eq("merchant")
      expect(user.merchant?).to be_truthy
    end
  end
end
