require 'rails_helper'

RSpec.describe "User" do
  describe "can register" do
    it "succsefully" do
      visit '/'

      click_link "Register"

      expect(current_path).to eq("/register")

      username = "funbucket13"
      password = "test"
      address = "54321"
      city = "Denver"
      state = "Colorado"
      zip = "12345"
      email = "someone@gmail.com"

      fill_in :username, with: username
      fill_in :address, with: address
      fill_in :city, with: city
      fill_in :state, with: state
      fill_in :zip, with: zip
      fill_in :email, with: email
      fill_in :password, with: password
      fill_in :confirmation_password, with: password

      click_button "Register"

      expect(current_path).to eq("/profile")
      expect(page).to have_content("You are now registered and logged in.")
    end

    xit "unsuccsefully" do
      it "when pre-existing email is used to register" do

      end

      it "when field is missing" do

      end
    end
  end
end
