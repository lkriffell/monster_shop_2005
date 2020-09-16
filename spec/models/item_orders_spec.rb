require 'rails_helper'

describe ItemOrder, type: :model do
  describe "validations" do
    it { should validate_presence_of :order_id }
    it { should validate_presence_of :item_id }
    it { should validate_presence_of :price }
    it { should validate_presence_of :quantity }
  end

  describe "relationships" do
    it {should belong_to :item}
    it {should belong_to :order}
  end

  describe 'instance methods' do
    it 'subtotal' do
      meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
      tire = meg.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
      user = User.create!(name: "bob", password: '12345', address: "street", city: "Denver", state: "CO", zip:"12345", email: "someone@gmail.com", role: 0)
      order_1 = Order.create!(name: 'Meg', address: '123 Stang Ave', city: 'Hershey', state: 'PA', zip: 17033, user: user)
      item_order_1 = order_1.item_orders.create!(item: tire, price: tire.price, quantity: 2)

      expect(item_order_1.subtotal).to eq(200)
    end

    # it 'can change status of every item included in one order' do
    #   @regular_user = User.create!(name: "barb", password: '12345', address: "street", city: "Denver", state: "CO", zip:"90210", email: "someone@gmail.com", role: 0)
    #
    #       allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@regular_user)
    #
    #   @bike_shop = Merchant.create!(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: "80203")
    #
    #   @tire = @bike_shop.items.create!(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
    #
    #   @order = Order.create!(name: "name", address: "address", city: "city", state: "state", zip: "80210", user_id: @regular_user.id, status: "pending")
    #
    #   ItemOrder.create!(order_id: @order.id, price: 1.0, item_id: @tire.id, quantity: 4)
    #
    #   visit '/profile'
    #
    #   click_link "My Orders"
    #   expect(current_path).to eq('/profile/orders')
    #     within "#order-#{@order.id}" do
    #       click_link "Order: #{@order.id}"
    #     end
    #
    #   expect(user.role).to eq("regular")
    #   expect(user.regular?).to be_truthy
    #
    #   @order.item_orders.each do |item|
    #     expect(page).to have_content("Blah")
    #     require "pry"; binding.pry
    #   end
    # end
  end

end
