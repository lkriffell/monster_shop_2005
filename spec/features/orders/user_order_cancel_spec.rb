require "rails_helper"

RSpec.describe "Registered User Cancel Order" do
  it "When I visit my profile orders page, I see a button to cancel my orders" do

    @regular_user = User.create!(name: "barb", password: '12345', address: "street", city: "Denver", state: "CO", zip:"90210", email: "someone@gmail.com", role: 0)

    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@regular_user)

    @bike_shop = Merchant.create!(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: "80203")

    @merchant_user = @bike_shop.users.create!(name: "barb", password: '12345', address: "street", city: "Denver", state: "CO", zip:"90210", email: "somefour@gmail.com", role: 1)

    @tire = @bike_shop.items.create!(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)

    @order = Order.create!(name: "name", address: "address", city: "city", state: "state", zip: "80210", user_id: @regular_user.id, status: "pending")


    ItemOrder.create!(order_id: @order.id, price: 1.0, item_id: @tire.id, quantity: 4, status: 1)


    visit '/profile'

    click_link "My Orders"
    expect(current_path).to eq('/profile/orders')
      within "#order-#{@order.id}" do
        click_link "Order: #{@order.id}"
      end

    expect(page).to have_button("Cancel Order")
    click_on "Cancel Order"
    expect(current_path).to eq("/profile")


    @order.item_orders.each do |item_order|
      item_order.reload
      expect(item_order.status).to eq("unfulfilled")
    end
    @order.reload
    expect(@order.status).to eq("cancelled")

    expect(page).to have_content("Order-#{@order.id} is now #{@order.status}")

    @tire.reload

    expect(@tire.inventory).to eq(16)

  end
end
