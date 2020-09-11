require 'rails_helper'

RSpec.describe "if logged in" do
  describe "user" do
    it 'is directed to their profile' do
      User.create!(name: "bob", password: '12345', address: "street", city: "Denver", state: "CO", zip:"12345", email: "someone@gmail.com")

      visit '/'

      click_link "Log in"

      email = "someone@gmail.com"
      password = "12345"

      fill_in :email, with: email
      fill_in :password, with: password

      click_button "Log in"

      expect(current_path).to eq('/profile')
      expect(page).to have_content('Welcome, bob!')

    end
  end

  describe "admin" do
    it 'is directed to their dashboard' do
      User.create!(name: "bob", password: '12345', address: "street", city: "Denver", state: "CO", zip:"12345", email: "admin@gmail.com", role: 1)

      visit '/'

      click_link "Log in"

      email = "admin@gmail.com"
      password = "12345"

      fill_in :email, with: email
      fill_in :password, with: password

      click_button "Log in"

      expect(current_path).to eq('/admin/dashboard')
      expect(page).to have_content('Welcome, bob!')

    end
  end

  describe "merchant user" do
    it 'is directed to their dashboard' do
      User.create!(name: "bob", password: '12345', address: "street", city: "Denver", state: "CO", zip:"12345", email: "merchant@gmail.com", role: 2)

      visit '/'

      click_link "Log in"

      email = "merchant@gmail.com"
      password = "12345"

      fill_in :email, with: email
      fill_in :password, with: password

      click_button "Log in"

      expect(current_path).to eq('/merchant/dashboard')
      expect(page).to have_content('Welcome, bob!')
    end
  end

  describe "with incorrect credentials" do
    it 'user is directed back to login' do
      User.create!(name: "bob", password: '12345', address: "street", city: "Denver", state: "CO", zip:"12345", email: "admin@gmail.com", role: 1)

      visit '/'

      click_link "Log in"

      email = "admin@gmail.com"

      fill_in :email, with: email
      fill_in :password, with: ''

      click_button "Log in"

      expect(current_path).to eq('/login')
      expect(page).to have_content('Sorry, your credentials are bad.')
    end
  end

  describe "as default user" do
    it 'does not allow default user to see admin dashboard index' do
      user = User.create!(name: "bob", password: '12345', address: "street", city: "Denver", state: "CO", zip:"12345", email: "someone@gmail.com")


      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)

      visit "/admin/dashboard"

      expect(page).to have_content("The page you were looking for doesn't exist.")
    end
  end

  describe "and a user visits the login page" do
    it 'user is redirected to their profile' do
      User.create!(name: "bob", password: '12345', address: "street", city: "Denver", state: "CO", zip:"12345", email: "someone@gmail.com")

      visit '/'

      click_link 'Log in'

      email = "someone@gmail.com"
      password = "12345"

      fill_in :email, with: email
      fill_in :password, with: password

      click_button "Log in"
      click_link "Log in"

      expect(current_path).to eq('/profile')

      expect(page).to have_content("You are already logged in.")
    end

    it 'admin is redirected to their dashboard' do
      User.create!(name: "bob", password: '12345', address: "street", city: "Denver", state: "CO", zip:"12345", email: "admin@gmail.com", role: 1)

      visit '/'

      click_link "Log in"

      email = "admin@gmail.com"
      password = "12345"

      fill_in :email, with: email
      fill_in :password, with: password

      click_button "Log in"
      click_link "Log in"

      expect(current_path).to eq('/admin/dashboard')

      expect(page).to have_content("You are already logged in.")
    end

    it 'merchant is redirected to their dashboard' do
      User.create!(name: "bob", password: '12345', address: "street", city: "Denver", state: "CO", zip:"12345", email: "merchant@gmail.com", role: 2)

      visit '/'

      click_link "Log in"

      email = "merchant@gmail.com"
      password = "12345"

      fill_in :email, with: email
      fill_in :password, with: password

      click_button "Log in"
      click_link "Log in"

      expect(current_path).to eq('/merchant/dashboard')

      expect(page).to have_content("You are already logged in.")
    end
  end
end
