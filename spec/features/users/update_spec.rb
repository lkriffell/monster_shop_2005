require 'rails_helper'

describe 'User profile edit page' do
  it 'allows the user to edit information' do
    user = User.create!(name: "Bob", password: '12345', address: "street", city: "Los Angeles", state: "CA", zip:"90210", email: "someone@gmail.com", role: 0)

    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)

    visit "/profile"
    click_link "Edit Profile"

    expect(current_path).to eq('/profile/edit')

    within('form') do
      expect(find_field(:user_name).value).to eq(user.name)
      expect(find_field(:user_address).value).to eq(user.address)
      expect(find_field(:user_city).value).to eq(user.city)
      expect(find_field(:user_state).value).to eq(user.state)
      expect(find_field(:user_zip).value).to eq(user.zip)
      expect(find_field(:user_email).value).to eq(user.email)
    end

    new_name = "Joe Dude"
    new_address = "54321"
    new_city = "Denver"
    new_state = "Colorado"
    new_zip = "99009"
    new_email = "someone@gmail.com"

    fill_in :user_name, with: new_name
    fill_in :user_address, with: new_address
    fill_in :user_city, with: new_city
    fill_in :user_state, with: new_state
    fill_in :user_zip, with: new_zip
    fill_in :user_email, with: new_email
    fill_in :user_password, with: user.password
    fill_in :user_password_confirmation, with: user.password

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
  it 'fails to update when email is not unique' do
    user = User.create!(name: "Bob", password: '12345', address: "street", city: "Los Angeles", state: "CA", zip:"90210", email: "someone@gmail.com", role: 0)
    user2 = User.create!(name: "John", password: '12345', address: "street", city: "Los Angeles", state: "CA", zip:"90210", email: "someone.else@gmail.com", role: 0)

    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)

    visit "/profile"
    click_link "Edit Profile"

    new_email = "someone.else@gmail.com"

    fill_in :user_email, with: new_email
    fill_in :user_password, with: user.password

    click_on "Update Profile"
    expect(current_path).to eq('/profile')

    expect(page).to have_content("Email has already been taken")
  end

  it 'has an edit password link which allows user to edit password' do
    user = User.create!(name: "Bob", password: '12345', address: "street", city: "Los Angeles", state: "CA", zip:"90210", email: "someone@gmail.com", role: 0)

    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)

    visit "/profile"
    click_link "Edit Profile"
    click_link "Edit Password"

    expect(current_path).to eq('/profile/edit/password')

      expect(page).to have_field(:password)
      expect(page).to have_field(:password_confirmation)

    password = "123"

    fill_in :password, with: password
    fill_in :password_confirmation, with: password

    click_on "Update Password"
    expect(current_path).to eq('/profile')

    expect(page).to have_content("Your information has been updated.")
  end

  it 'has an edit password link which fails when user enters different confirmation password' do
    user = User.create!(name: "Bob", password: '12345', address: "street", city: "Los Angeles", state: "CA", zip:"90210", email: "someone@gmail.com", role: 0)

    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)

    visit "/profile"
    click_link "Edit Profile"
    click_link "Edit Password"

    expect(current_path).to eq('/profile/edit/password')

      expect(page).to have_field(:password)
      expect(page).to have_field(:password_confirmation)

    password = "123"

    fill_in :password, with: password
    fill_in :password_confirmation, with: "Hi"

    click_on "Update Password"
    expect(current_path).to eq('/profile')

    expect(page).to have_content("Password confirmation doesn't match Password")
  end
end
