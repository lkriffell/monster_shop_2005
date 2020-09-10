require 'rails_helper'

RSpec.describe "User" do
  describe "can register" do
    it "successfully" do
      visit '/'

      click_link "Register"

      expect(current_path).to eq("/register")

      name = "Joe Dude"
      password = "test"
      address = "54321"
      city = "Denver"
      state = "Colorado"
      zip = "12345"
      email = "someone@gmail.com"

      fill_in :name, with: name
      fill_in :address, with: address
      fill_in :city, with: city
      fill_in :state, with: state
      fill_in :zip, with: zip
      fill_in :email, with: email
      fill_in :password, with: password
      fill_in :password_confirmation, with: password

      click_button "Register"

      expect(current_path).to eq("/profile")
      expect(page).to have_content("You are now registered and logged in.")
    end

    describe "unsuccessfully" do
      it "when pre-existing email is used to register" do
        User.create!(name: "bob", password: '12345', address: "street", city: "Denver", state: "CO", zip:"12345", email: "someone@gmail.com")

        visit '/'

        click_link "Register"

        expect(current_path).to eq("/register")

        name = "Joe Dude"
        password = "test"
        address = "54321"
        city = "Denver"
        state = "Colorado"
        zip = "12345"
        email = "someone@gmail.com"

        fill_in :name, with: name
        fill_in :address, with: address
        fill_in :city, with: city
        fill_in :state, with: state
        fill_in :zip, with: zip
        fill_in :email, with: email
        fill_in :password, with: password
        fill_in :password_confirmation, with: password

        click_button "Register"
        expect(current_path).to eq("/register")

        expect(page).to have_content("Email has already been taken")

        expect(find_field(:name).value).to eq(name)
        expect(find_field(:address).value).to eq(address)
        expect(find_field(:city).value).to eq(city)
        expect(find_field(:state).value).to eq(state)
        expect(find_field(:zip).value).to eq(zip)
        expect(find_field(:email).value).to eq(nil)
        expect(find_field(:password).value).to eq(nil)
      end

      it "when field is missing" do
        visit '/'

        click_link "Register"

        expect(current_path).to eq("/register")

        fill_in :name, with: ""
        fill_in :address, with: ""
        fill_in :city, with: ""
        fill_in :state, with: ""
        fill_in :zip, with: ""
        fill_in :email, with: ""
        fill_in :password, with: ""
        fill_in :password_confirmation, with: ""

        click_button "Register"

        expect(current_path).to eq("/register")
        expect(page).to have_content("Email can't be blank, Address can't be blank, City can't be blank, State can't be blank, Zip can't be blank, Password can't be blank, Password can't be blank, and Name can't be blank")
      end
      it "when passwords dont match" do
        visit '/'

        click_link "Register"

        expect(current_path).to eq("/register")

        name = "Joe Dude"
        password = "test"
        address = "54321"
        city = "Denver"
        state = "Colorado"
        zip = "12345"
        email = "someone@gmail.com"

        fill_in :name, with: name
        fill_in :address, with: address
        fill_in :city, with: city
        fill_in :state, with: state
        fill_in :zip, with: zip
        fill_in :email, with: email
        fill_in :password, with: password
        fill_in :password_confirmation, with: "password"

        click_button "Register"

        expect(current_path).to eq("/register")
        expect(page).to have_content("Passwords must match")
      end
    end
  end
end
