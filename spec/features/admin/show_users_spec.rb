require 'rails_helper'

RSpec.describe "admin" do
  describe "can see all users through" do
    it "the all users page" do
      admin = User.create!(name: "bob", password: '12345', password_confirmation: '12345', address: "street", city: "Denver", state: "CO", zip:"12345", email: "someone@gmail.com", role: 1)
      user1 = User.create!(name: "jerry", password: '12345', password_confirmation: '12345', address: "street", city: "Denver", state: "CO", zip:"12345", email: "jerry@gmail.com", role: 0)
      user2 = User.create!(name: "nancy", password: '12345', password_confirmation: '12345', address: "street", city: "Denver", state: "CO", zip:"12345", email: "nancy@gmail.com", role: 0)
      user3 = User.create!(name: "john", password: '12345', password_confirmation: '12345', address: "street", city: "Denver", state: "CO", zip:"12345", email: "john@gmail.com", role: 0)
      
      visit '/'

      click_link "Log in"

      email = "someone@gmail.com"
      password = "12345"

      fill_in :email, with: email
      fill_in :password, with: password

      click_button "Log in"

      click_link 'All Users'

      expect(page).to have_content(user1.name)
      expect(page).to have_content(user2.name)
      expect(page).to have_content(user3.name)
    end
  end
end
