require 'rails_helper'

RSpec.describe "merchant dashboard" do
  describe "shows the merchant a user works for" do
    it "and it's details" do
      bike_shop = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
      merchant = User.create!(name: "bob", password: '12345', password_confirmation: '12345', address: "street", city: "Denver", state: "CO", zip:"12345", email: "someone@gmail.com", role: 1, merchant_id: bike_shop.id)

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(merchant)

      visit 'merchant/dashboard'

      expect(page).to have_content(bike_shop.name)
      expect(page).to have_content("#{bike_shop.address} #{bike_shop.city} #{bike_shop.state} #{bike_shop.zip}")
    end
    it "and their orders" do
      bike_shop = Merchant.create!(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
      tire = bike_shop.items.create!(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
      grip_tape = bike_shop.items.create!(name: "GripTape", description: "Keep your grip!", price: 80, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 6)
      order1 = Order.create!(name: "Order1", address: '726 My Rd.', city: 'Denver', state: 'CO', zip: 80203)
      order2 = Order.create!(name: "Order2", address: '231 This Rd.', city: 'Denver', state: 'CO', zip: 80203)
      item_order1 = ItemOrder.create!(order_id: order1.id, item_id: tire.id, price: 100, quantity: 1, created_at: 1999)
      item_order2 = ItemOrder.create!(order_id: order2.id, item_id: grip_tape.id, price: 80, quantity: 1, created_at: 1999)
      merchant = User.create!(name: "bob", password: '12345', password_confirmation: '12345', address: "street", city: "Denver", state: "CO", zip:"12345", email: "someone@gmail.com", role: 1, merchant_id: bike_shop.id)

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(merchant)

      visit 'merchant/dashboard'

      expect(page).to have_link(order1.id)
      expect(page).to have_content(order1.created_at.to_s[0..9])
      expect(page).to have_content(item_order1.quantity)
      expect(page).to have_content(item_order1.price)
      expect(page).to have_link(order2.id)
      expect(page).to have_content(order2.created_at.to_s[0..9])
      expect(page).to have_content(item_order2.quantity)
      expect(page).to have_content(item_order2.price)

      click_link order1.id
      expect(current_path).to eq("/orders/#{order1.id}")

      visit '/merchant/dashboard'

      click_link order2.id
      expect(current_path).to eq("/orders/#{order2.id}")
    end
  end
end
