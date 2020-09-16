require 'rails_helper'

RSpec.describe 'merchant index page', type: :feature do
  describe 'As a user' do
    before :each do
      @bike_shop = Merchant.create(name: "Brian's Bike Shop", address: '123 Bike Rd.', city: 'Richmond', state: 'VA', zip: 80203)
      @dog_shop = Merchant.create(name: "Meg's Dog Shop", address: '123 Dog Rd.', city: 'Hershey', state: 'PA', zip: 80203)
    end

    it 'I can see a list of merchants in the system' do
      visit '/merchants'

      expect(page).to have_link("Brian's Bike Shop")
      expect(page).to have_link("Meg's Dog Shop")
    end

    it 'I can see a link to create a new merchant' do
      visit '/merchants'

      expect(page).to have_link("New Merchant")

      click_on "New Merchant"

      expect(current_path).to eq("/merchants/new")
    end
  end

  describe 'As an admin user' do
    before :each do
      @bike_shop = Merchant.create(name: "Brian's Bike Shop", address: '123 Bike Rd.', city: 'Richmond', state: 'VA', zip: 80203)

      @admin = User.create!(name: "bob", password: '12345', password_confirmation: '12345', address: "street", city: "Denver", state: "CO", zip:"12345", email: "someone@gmail.com", role: 2)

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@admin)
    end

    it "can click on a merchant's name and go to the merchant dashboard" do
      visit '/merchants'

      click_on "Brian's Bike Shop"

      expect(current_path).to eq("/admin/merchants/#{@bike_shop.id}")
    end

    it "can see everything a merchant sees" do
      merchant = User.create!(name: "bob", password: '12345', password_confirmation: '12345', address: "street", city: "Denver", state: "CO", zip:"12345", email: "bazinga@gmail.com", role: 1, merchant_id: @bike_shop.id)

      tire = @bike_shop.items.create!(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
      grip_tape = @bike_shop.items.create!(name: "GripTape", description: "Keep your grip!", price: 80, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 6)

      order1 = Order.create!(name: "Order1", address: '726 My Rd.', city: 'Denver', state: 'CO', zip: 80203, user: merchant)
      order2 = Order.create!(name: "Order2", address: '231 This Rd.', city: 'Denver', state: 'CO', zip: 80203, user: merchant)

      item_order1 = ItemOrder.create!(order_id: order1.id, item_id: tire.id, price: 100, quantity: 1, created_at: 1999)
      item_order2 = ItemOrder.create!(order_id: order2.id, item_id: grip_tape.id, price: 80, quantity: 1, created_at: 1999)

      visit '/merchants'

      click_on "Brian's Bike Shop"

      expect(page).to have_content(@bike_shop.name)
      expect(page).to have_content("#{@bike_shop.address} #{@bike_shop.city} #{@bike_shop.state} #{@bike_shop.zip}")

      expect(page).to have_link(order1.id)
      expect(page).to have_content(order1.created_at.to_s[0..9])
      expect(page).to have_content(item_order1.quantity)
      expect(page).to have_content(item_order1.price)
      expect(page).to have_link(order2.id)
      expect(page).to have_content(order2.created_at.to_s[0..9])
      expect(page).to have_content(item_order2.quantity)
      expect(page).to have_content(item_order2.price)
    end
  end
end
