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


  describe "roles" do
    it "can be created as a merchant" do
      merchant = User.create(name: "penelope",
                         password: "boom",
                         role: 2)

      expect(merchant.role).to eq("merchant")
      expect(merchant.merchant?).to be_truthy
    end
    it "can be created as an admin" do
      admin = User.create(name: "penelope",
                         password: "boom",
                         role: 1)

      expect(admin.role).to eq("admin")
      expect(admin.admin?).to be_truthy
    end

    it "can be created as a default user" do
      user = User.create(name: "sammy",
                         password: "pass",
                         role: 0)

      expect(user.role).to eq("default")
      expect(user.default?).to be_truthy
    end
  end
end
