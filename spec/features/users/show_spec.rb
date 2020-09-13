# User Story 19, User Profile Show Page
#
# As a registered user
# When I visit my profile page
# Then I see all of my profile data on the page except my password
# And I see a link to edit my profile data

require 'rails_helper'

describe 'User profile show page' do
  it 'display all user info except password and has an edit link' do
    user = User.create!(name: "bob", password: '12345', address: "street", city: "Denver", state: "CO", zip:"90210", email: "someone@gmail.com", role: 0)

    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)

    visit "/profile"

    expect(page).to have_content(user.name)
    expect(page).to have_content(user.address)
    expect(page).to have_content(user.city)
    expect(page).to have_content(user.state)
    expect(page).to have_content(user.zip)
    expect(page).to have_content(user.email)
    expect(page).not_to have_content(user.password)
    expect(page).to have_link("Edit Profile")
  end
end
