require 'rails_helper'

RSpec.describe "User" do
  describe "can register" do
    it "successfully" do
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

    describe "unsuccessfully" do
      xit "when pre-existing email is used to register" do
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
      end

      it "when field is missing" do
        visit '/'

        click_link "Register"

        expect(current_path).to eq("/register")

        fill_in :username, with: ""
        fill_in :address, with: ""
        fill_in :city, with: ""
        fill_in :state, with: ""
        fill_in :zip, with: ""
        fill_in :email, with: ""
        fill_in :password, with: ""
        fill_in :confirmation_password, with: ""

        click_button "Register"

        expect(current_path).to eq("/register")
        expect(page).to have_content("You must fill out all fields to register.")
      end
    end
  end
end
