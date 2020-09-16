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

      fill_in :user_name, with: name
      fill_in :user_address, with: address
      fill_in :user_city, with: city
      fill_in :user_state, with: state
      fill_in :user_zip, with: zip
      fill_in :user_email, with: email
      fill_in :user_password, with: password
      fill_in :user_password_confirmation, with: password

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

        fill_in :user_name, with: name
        fill_in :user_address, with: address
        fill_in :user_city, with: city
        fill_in :user_state, with: state
        fill_in :user_zip, with: zip
        fill_in :user_email, with: email
        fill_in :user_password, with: password
        fill_in :user_password_confirmation, with: password

        click_button "Register"
        expect(current_path).to eq("/register")

        expect(page).to have_content("Email has already been taken")

        expect(find_field(:user_name).value).to eq(name)
        expect(find_field(:user_address).value).to eq(address)
        expect(find_field(:user_city).value).to eq(city)
        expect(find_field(:user_state).value).to eq(state)
        expect(find_field(:user_zip).value).to eq(zip)
        expect(find_field(:user_email).value).to eq(nil)
        expect(find_field(:password).value).to eq(nil)
      end

      it "when field is missing" do
        visit '/'

        click_link "Register"

        expect(current_path).to eq("/register")

        fill_in :user_name, with: ""
        fill_in :user_address, with: ""
        fill_in :user_city, with: ""
        fill_in :user_state, with: ""
        fill_in :user_zip, with: ""
        fill_in :user_email, with: ""
        fill_in :user_password, with: ""
        fill_in :user_password_confirmation, with: ""

        click_button "Register"

        expect(current_path).to eq("/register")
        expect(page).to have_content("Email can't be blank, Password confirmation doesn't match Password, Password can't be blank, Address can't be blank, City can't be blank, State can't be blank, Zip can't be blank, and Name can't be blank")
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

        fill_in :user_name, with: name
        fill_in :user_address, with: address
        fill_in :user_city, with: city
        fill_in :user_state, with: state
        fill_in :user_zip, with: zip
        fill_in :user_email, with: email
        fill_in :user_password, with: password
        fill_in :user_password_confirmation, with: "password"

        click_button "Register"

        expect(current_path).to eq("/register")
        expect(page).to have_content("Password confirmation doesn't match Password")
      end
    end
  end
end
