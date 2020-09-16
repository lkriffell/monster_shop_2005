# User Story 30, User cancels an order
#



require "rails_helper"

RSpec.describe "Registered User Order" do
  it "When I visit my profile orders page, I see all information about the order" do

    @regular_user = User.create!(name: "barb", password: '12345', address: "street", city: "Denver", state: "CO", zip:"90210", email: "someone@gmail.com", role: 0)

        allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@regular_user)

    @bike_shop = Merchant.create!(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: "80203")

    @tire = @bike_shop.items.create!(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)

    @order = Order.create!(name: "name", address: "address", city: "city", state: "state", zip: "80210", user_id: @regular_user.id, status: "pending")

    ItemOrder.create!(order_id: @order.id, price: 1.0, item_id: @tire.id, quantity: 4)

    visit '/profile'

    click_link "My Orders"
    expect(current_path).to eq('/profile/orders')
      within "#order-#{@order.id}" do
        click_link "Order: #{@order.id}"
      end

    expect(page).to have_button("Cancel Order")
# I see a button or link to cancel the order
# When I click the cancel button for an order, the following happens:
#
# Each row in the "order items" table is given a status of "unfulfilled"
# The order itself is given a status of "cancelled"
# Any item quantities in the order that were previously fulfilled have their quantities returned to their respective merchant's inventory for that item.
# I am returned to my profile page
# I see a flash message telling me the order is now cancelled
# And I see that this order now has an updated status of "cancelled"















    expect(current_path).to eq("/profile/orders/#{@order.id}")

    expect(page).to have_content("Order No. #{@order.id}")
    expect(page).to have_content("Created at: #{@order.created_at}")
    expect(page).to have_content("Updated at: #{@order.updated_at}")
    expect(page).to have_content("Current Status: #{@order.status}")
    @order.item_orders.each do |item_order|

      within "#item-#{item_order.item_id}" do
        expect(page).to have_content("#{@tire.name}")
        expect(page).to have_content("#{@tire.description}")

        expect(page).to have_selector("img[src*='#{@tire.image}']")
        expect(page).to have_content("#{item_order.quantity}")
        expect(page).to have_content("#{item_order.price}")
        expect(page).to have_content("#{item_order.subtotal}")
      end
    end
    expect(page).to have_content("Number of Items: #{@order.total_quantity}")
    expect(page).to have_content("Total: $#{@order.grandtotal}0")

  end
end
