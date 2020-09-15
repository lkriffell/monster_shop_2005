require 'rails_helper'

describe 'Orders index page' do
  before(:each) do
    @user = User.create!(name: "bob", password: '12345', address: "street", city: "Denver", state: "CO", zip:"90210", email: "newemail@gmail.com", role: 0)

    #merchants
    @bike_shop = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
    @dog_shop = Merchant.create(name: "Brian's Dog Shop", address: '125 Doggo St.', city: 'Denver', state: 'CO', zip: 80210)

    #bike_shop items
    @tire = @bike_shop.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)

    #dog_shop items
    @pull_toy = @dog_shop.items.create(name: "Pull Toy", description: "Great pull toy!", price: 10, image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg", inventory: 32)
    @dog_bone = @dog_shop.items.create(name: "Dog Bone", description: "They'll love it!", price: 21, image: "https://img.chewy.com/is/image/catalog/54226_MAIN._AC_SL1500_V1534449573_.jpg", active?:false, inventory: 21)

    #orders
    @order1 = @user.orders.create!(name: @user.name, address: @user.address, city: @user.city, state: @user.state, zip: @user.zip)

    @order1.item_orders.create({
      item: @tire,
      quantity: 2,
      price: @tire.price
      })

    @order2 = @user.orders.create!(name: @user.name, address: @user.address, city: @user.city, state: @user.state, zip: @user.zip)

    @order2.item_orders.create({
      item: @pull_toy,
      quantity: 10,
      price: @pull_toy.price
      })

    @order2.item_orders.create({
      item: @dog_bone,
      quantity: 11,
      price: @dog_bone.price
      })

    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)
  end

  it "has a link to all the user's orders" do
    visit "/profile"
    expect(page).to have_link("My Orders")

    click_on "My Orders"
    expect(current_path).to eq("/profile/orders")
  end

  it 'has information for all my index_orders_on_user_id' do
    visit "/profile"
    click_on "My Orders"

    allow_any_instance_of(Order).to receive(:status).and_return("pending")

    within("#order-#{@order1.id}") do
      expect(page).to have_content(@order1.id)
      expect(page).to have_content(@order1.updated_at)
      # expect(page).to have_content(@order1.status)
      expect(page).to have_content(@order1.total_quantity)
      expect(page).to have_content(@order1.grandtotal)
    end

    within("#order-#{@order2.id}") do
      expect(page).to have_content(@order2.id)
      expect(page).to have_content(@order2.updated_at)
      # expect(page).to have_content(@order2.status)
      expect(page).to have_content(@order2.total_quantity)
      expect(page).to have_content(@order2.grandtotal)
    end
  end
end
