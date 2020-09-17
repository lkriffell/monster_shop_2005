require 'rails_helper'

RSpec.describe("Show Order Page") do
  describe "Shows item, image, price, name, address" do
    before :each do
      shop = create(:merchant)
      shop2 = create(:merchant)
      merchant = create(:merchant_user, merchant_id: shop.id)
      @item1 = create(:item, merchant_id: shop.id, inventory: 20)
      @item2 = create(:item, merchant_id: shop2.id)
      user = create(:user)
      @order = create(:order, user_id: user.id)
      create(:item_order, order_id: @order.id, item_id: @item2.id, price: @item2.price)
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(merchant)
    end

    it 'as well as price and quantity' do
      @item_order = create(:item_order, order_id: @order.id, item_id: @item1.id, price: @item1.price)

      visit "/orders/#{@order.id}"

      expect(page).to have_content(@order.name)
      expect(page).to have_content(@order.address)
      expect(page).to have_content(@order.city)
      expect(page).to have_content(@order.state)
      expect(page).to have_content(@order.zip)
      expect(page).to have_content(@item1.name)
      expect(page).to have_css("img[src*='#{@item1.image}']")
      expect(page).to have_content(@item_order.price)
      expect(page).to have_content(@item_order.quantity)
      expect(page).to_not have_content(@item2.name)
    end

    it 'and can fulfill an item in an order and item inventory decreases' do
      @item_order = create(:item_order, order_id: @order.id, item_id: @item1.id, price: @item1.price, quantity: 1)

      visit "/orders/#{@order.id}"

      expect(@item1.inventory).to eq(20)

      expect(page).to have_link("Fulfill Order")
      click_on "Fulfill Order"

      @item1.reload

      expect(@item1.inventory).to eq(19)

      expect(current_path).to eq("/orders/#{@order.id}")
      expect(page).to have_content("Order has been fulfilled.")
      expect(page).to_not have_link("Fulfill Order")

    end
    it 'and cannot fulfill an item in an order if more items are ordered than in inventory' do
      @item_order = create(:item_order, order_id: @order.id, item_id: @item1.id, price: @item1.price, quantity: 500)

      visit "/orders/#{@order.id}"

      expect(page).to_not have_link("Fulfill Order")
      expect(page).to have_content("This order cannot be fulfilled due to lack of inventory.")
    end
  end
end
