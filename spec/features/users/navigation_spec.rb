require 'rails_helper'

RSpec.describe "navigation" do
  describe "has all links for" do
    it 'a visitor' do
      visit '/'

        expect(page).to have_link('Home')
        expect(page).to have_link('All Merchants')
        expect(page).to have_link('All Items')
        expect(page).to have_link('Cart: 0')
        expect(page).to have_link('Register')
        expect(page).to have_link('Log in')

        click_link 'Home'
        expect(current_path).to eq('/')

        click_link 'All Merchants'
        expect(current_path).to eq('/merchants')
        click_link 'Home'

        click_link 'All Items'
        expect(current_path).to eq('/items')
        click_link 'Home'

        click_link 'Cart: 0'
        expect(current_path).to eq('/cart')
        click_link 'Home'

        click_link 'Register'
        expect(current_path).to eq('/register')
        click_link 'Home'

        click_link 'Log in'
        expect(current_path).to eq('/login')
        click_link 'Home'
    end
    it 'a user' do
      visit '/'

      user = create(:user)
      click_link "Log in"

      fill_in :email, with: user.email
      fill_in :password, with: user.password

      click_button "Log in"

      visit '/'

        expect(page).to have_link('Home')
        expect(page).to have_link('All Merchants')
        expect(page).to have_link('All Items')
        expect(page).to have_link('Cart: 0')
        expect(page).to have_link('Log out')
        expect(page).not_to have_link('Log in')
        expect(page).to have_link('Profile')
        expect(page).to have_content("Logged in as #{user.name}")

        click_link 'Home'
        expect(current_path).to eq('/')

        click_link 'All Merchants'
        expect(current_path).to eq('/merchants')
        click_link 'Home'

        click_link 'All Items'
        expect(current_path).to eq('/items')
        click_link 'Home'

        click_link 'Cart: 0'
        expect(current_path).to eq('/cart')
        click_link 'Home'

        click_link 'Profile'
        expect(current_path).to eq('/profile')
        click_link 'Home'

        click_link 'Log out'
        expect(current_path).to eq('/')
        click_link 'Home'
    end
    it 'an admin' do
      visit '/'

      admin = create(:admin)
      click_link "Log in"

      fill_in :email, with: admin.email
      fill_in :password, with: admin.password

      click_button "Log in"

      visit '/'
        expect(page).to have_link('Home')
        expect(page).to have_link('All Merchants')
        expect(page).to have_link('All Items')
        expect(page).to have_link('Log out')
        expect(page).not_to have_link('Log in')
        expect(page).not_to have_link('Cart: 0')
        expect(page).to have_link('Profile')
        expect(page).to have_link('Dashboard')
        expect(page).to have_link('All Users')
        expect(page).to have_content("Logged in as #{admin.name}")

        click_link 'Home'
        expect(current_path).to eq('/')

        click_link 'All Merchants'
        expect(current_path).to eq("/admin/merchants")
        click_link 'Home'

        click_link 'All Items'
        expect(current_path).to eq('/items')
        click_link 'Home'

        click_link 'Profile'
        expect(current_path).to eq('/profile')
        click_link 'Home'

        click_link 'Dashboard'
        expect(current_path).to eq('/admin/dashboard')
        click_link 'Home'

        click_link 'All Users'
        expect(current_path).to eq('/admin/users')
        click_link 'Home'

        click_link 'Log out'
        expect(current_path).to eq('/')
        click_link 'Home'
    end
    it 'a merchant' do
      visit '/'
      shop = create(:merchant)
      merchant = create(:merchant_user, merchant_id: shop.id)

      click_link "Log in"

      fill_in :email, with: merchant.email
      fill_in :password, with: merchant.password

      click_button "Log in"

      visit '/'

        expect(page).to have_link('Home')
        expect(page).to have_link('All Merchants')
        expect(page).to have_link('All Items')
        expect(page).to have_link('Cart: 0')
        expect(page).to have_link('Log out')
        expect(page).not_to have_link('Log in')
        expect(page).to have_link('Profile')
        expect(page).to have_link('Dashboard')
        expect(page).to have_content("Logged in as #{merchant.name}")

        click_link 'Home'
        expect(current_path).to eq('/')

        click_link 'All Merchants'
        expect(current_path).to eq('/merchants')
        click_link 'Home'

        click_link 'All Items'
        expect(current_path).to eq('/items')
        click_link 'Home'

        click_link 'Cart: 0'
        expect(current_path).to eq('/cart')
        click_link 'Home'

        click_link 'Profile'
        expect(current_path).to eq('/profile')
        click_link 'Home'

        click_link 'Dashboard'
        expect(current_path).to eq('/merchant/dashboard')
        click_link 'Home'

        click_link 'Log out'
        expect(current_path).to eq('/')
        click_link 'Home'
    end
  end

  describe "restricts" do
    it "visitor from accessing merchant, admin and profile" do
      visit '/'

      visit '/profile'
      expect(page).to have_content("404")
      visit '/merchant/dashboard'
      expect(page).to have_content("404")
      visit '/admin/dashboard'
      expect(page).to have_content("404")
      visit '/admin/users'
      expect(page).to have_content("404")
    end

    it "user from accessing merchant and admin" do
      User.create!(name: "bob", password: '12345', password_confirmation: '12345', address: "street", city: "Denver", state: "CO", zip:"12345", email: "someone@gmail.com", role: 0)
      visit '/'

      click_link "Log in"
      fill_in :email, with: "someone@gmail.com"
      fill_in :password, with: "12345"
      click_button "Log in"

      visit '/merchant/dashboard'
      expect(page).to have_content("404")
      visit '/admin/dashboard'
      expect(page).to have_content("404")
      visit '/admin/users'
      expect(page).to have_content("404")
    end

    it "admin from accessing merchant and cart" do
      User.create!(name: "bob", password: '12345', password_confirmation: '12345', address: "street", city: "Denver", state: "CO", zip:"12345", email: "someone@gmail.com", role: 2)
      visit '/'

      click_link "Log in"
      fill_in :email, with: "someone@gmail.com"
      fill_in :password, with: "12345"
      click_button "Log in"

      visit '/merchant/dashboard'
      expect(page).to have_content("404")
      visit '/cart'
      expect(page).to have_content("404")
    end

    it "merchant from accessing admin" do
      bike_shop = Merchant.create!(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
      merchant = User.create!(name: "bob", password: '12345', address: "street", city: "Denver", state: "CO", zip:"12345", email: "someone@gmail.com", role: 1, merchant_id: bike_shop.id)
      visit '/'

      click_link "Log in"
      fill_in :email, with: "someone@gmail.com"
      fill_in :password, with: "12345"
      click_button "Log in"

      visit '/admin/dashboard'
      expect(page).to have_content("404")
      visit '/admin/users'
      expect(page).to have_content("404")
    end
  end
end
