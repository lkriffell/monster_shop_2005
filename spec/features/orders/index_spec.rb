require 'rails_helper'

describe 'Orders index page' do
  it "has a link to all the user's orders" do
    user = User.create!(name: "bob", password: '12345', address: "street", city: "Denver", state: "CO", zip:"90210", email: "someone@gmail.com", role: 0)

    # #merchants
    # bike_shop = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
    # dog_shop = Merchant.create(name: "Brian's Dog Shop", address: '125 Doggo St.', city: 'Denver', state: 'CO', zip: 80210)
    #
    # #bike_shop items
    # tire = bike_shop.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
    #
    # #dog_shop items
    # pull_toy = dog_shop.items.create(name: "Pull Toy", description: "Great pull toy!", price: 10, image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg", inventory: 32)
    # dog_bone = dog_shop.items.create(name: "Dog Bone", description: "They'll love it!", price: 21, image: "https://img.chewy.com/is/image/catalog/54226_MAIN._AC_SL1500_V1534449573_.jpg", active?:false, inventory: 21)
    #
    # order1 = user.orders.create!()

    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)

    visit "/profile"

    expect(page).to have_link("My Orders")

    click_on "My Orders"

    expect(current_path).to eq("/profile/orders")


  end
end
