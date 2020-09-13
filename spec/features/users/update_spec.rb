require 'rails_helper'

describe 'User profile edit page' do
  it 'allows the user to edit information' do
    user = User.create!(name: "Bob", password: '12345', address: "street", city: "Los Angeles", state: "CA", zip:"90210", email: "someone@gmail.com", role: 0)

    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)

    visit "/profile"
    click_link "Edit Profile"

    expect(current_path).to eq('/profile/edit')

    within('form') do
      expect(find_field(:name).value).to eq(user.name)
      expect(find_field(:address).value).to eq(user.address)
      expect(find_field(:city).value).to eq(user.city)
      expect(find_field(:state).value).to eq(user.state)
      expect(find_field(:zip).value).to eq(user.zip)
      expect(find_field(:email).value).to eq(user.email)
    end

    new_name = "Joe Dude"
    new_address = "54321"
    new_city = "Denver"
    new_state = "Colorado"
    new_zip = "99009"
    new_email = "someone@gmail.com"

    fill_in :name, with: new_name
    fill_in :address, with: new_address
    fill_in :city, with: new_city
    fill_in :state, with: new_state
    fill_in :zip, with: new_zip
    fill_in :email, with: new_email

    click_on "Update Profile"
    expect(current_path).to eq('/profile')

    expect(page).to have_content("Your information has been updated.")

    expect(page).to have_content(new_name)
    expect(page).to have_content(new_address)
    expect(page).to have_content(new_city)
    expect(page).to have_content(new_state)
    expect(page).to have_content(new_zip)
    expect(page).to have_content(new_email)
    expect(page).not_to have_content(user.password)
  end
end
