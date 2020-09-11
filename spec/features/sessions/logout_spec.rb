require 'rails_helper'

RSpec.describe "when loggin out" do
  describe "visitor" do
    it 'is directed to root path and cart empties' do
      dog_shop = Merchant.create(name: "Brian's Dog Shop", address: '125 Doggo St.', city: 'Denver', state: 'CO', zip: 80210)
      pull_toy = dog_shop.items.create(name: "Pull Toy", description: "Great pull toy!", price: 10, image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg", inventory: 32)
      User.create!(name: "bob", password: '12345', address: "street", city: "Denver", state: "CO", zip:"12345", email: "someone@gmail.com")

      visit '/'

      click_link "Log in"

      email = "someone@gmail.com"
      password = "12345"

      fill_in :email, with: email
      fill_in :password, with: password

      click_button "Log in"

      visit "/items/#{pull_toy.id}"
      click_button "Add To Cart"

      click_link "Log out"

      expect(current_path).to eq('/')
      expect(page).to have_content('Cart: 0')
    end
  end
end
