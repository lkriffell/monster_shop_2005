require 'rails_helper'

RSpec.describe "merchant dashboard" do
  describe "shows the merchant a user works for" do
    xit "and it's details" do
      bike_shop = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
      user = User.create!(name: "bob", password: '12345', password_confirmation: '12345', address: "street", city: "Denver", state: "CO", zip:"12345", email: "someone@gmail.com", role: 1, merchant_id: bike_shop.id)

      visit '/'

      click_link "Log in"

      email = "someone@gmail.com"
      password = "12345"

      fill_in :email, with: email
      fill_in :password, with: password

      click_button "Log in"

      expect(page).to have_content(bike_shop.name)
      expect(page).to have_content("#{bike_shop.address} #{bike_shop.city} #{bike_shop.state} #{bike_shop.zip}")
    end
    it "and their orders" do
      bike_shop = Merchant.create!(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
      tire = bike_shop.items.create!(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
      order = Order.create!(name: "Order1", address: '726 My Rd.', city: 'Denver', state: 'CO', zip: 80203)
      item_order = ItemOrder.create!(order_id: order.id, item_id: tire.id, price: 100, quantity: 1, created_at: 1999)
      user = User.create!(name: "bob", password: '12345', password_confirmation: '12345', address: "street", city: "Denver", state: "CO", zip:"12345", email: "someone@gmail.com", role: 1, merchant_id: bike_shop.id)
      # require "pry"; binding.pry

      visit '/'

      click_link "Log in"

      email = "someone@gmail.com"
      password = "12345"

      fill_in :email, with: email
      fill_in :password, with: password

      click_button "Log in"

      expect(page).to have_link(order.id)
      expect(page).to have_content(order.created_at)
      expect(page).to have_content(item_order.quantity)
      expect(page).to have_content(item_order.price)

      click_link "#{order.id}"
      expect(current_path).to eq("/orders/#{order.id}")
    end
  end
end
# As a merchant employee
# When I visit my merchant dashboard ("/merchant")
# If any users have pending orders containing items I sell
# Then I see a list of these orders.
# Each order listed includes the following information:
#
# the ID of the order, which is a link to the order show page ("/merchant/orders/15")
# the date the order was made
# the total quantity of my items in the order
# the total value of my items for that order
