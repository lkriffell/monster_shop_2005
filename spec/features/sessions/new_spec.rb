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

  it 'merchant user in with valid credentials' do
    merchant = User.create!(name: "bob", password: '12345', address: "street", city: "Denver", state: "CO", zip:"12345", email: "someone@gmail.com", role: 1)

    visit "/login"

    fill_in :email, with: merchant.email
    fill_in :password, with: merchant.password

    click_button "Log In"

    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(merchant)

    expect(current_path).to eq("/merchant/dashboard")

    expect(page).to have_content("Hello, #{merchant.name}. You are now logged in.")
  end

  it 'admin user in with valid credentials' do
    admin = User.create!(name: "barb", password: '12345', address: "street", city: "Denver", state: "CO", zip:"12345", email: "somebody@gmail.com", role: 2)

    visit "/login"

    fill_in :email, with: admin.email
    fill_in :password, with: admin.password

    click_button "Log In"

    # allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(admin)

    expect(current_path).to eq("/admin/dashboard")

    expect(page).to have_content("Hello, #{admin.name}. You are now logged in.")
  end
end
