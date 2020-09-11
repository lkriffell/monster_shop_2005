require 'rails_helper'

describe "Logging In as" do
  it 'regular user in with valid credentials' do
    user = User.create!(name: "bob", password: '12345', address: "street", city: "Denver", state: "CO", zip:"12345", email: "someone@gmail.com", role: 0)

    visit "/login"

    fill_in :email, with: user.email
    fill_in :password, with: user.password

    click_button "Log In"

    expect(current_path).to eq("/profile")

    expect(page).to have_content("Hello, #{user.name}. You are now logged in.")
  end
end
