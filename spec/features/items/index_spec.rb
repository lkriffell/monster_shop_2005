require 'rails_helper'

RSpec.describe "Items Index Page" do
  describe "When I visit the items index page" do
    before(:each) do
      @meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
      @brian = Merchant.create(name: "Brian's Dog Shop", address: '125 Doggo St.', city: 'Denver', state: 'CO', zip: 80210)

      @tire = @meg.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)

      @pull_toy = @brian.items.create(name: "Pull Toy", description: "Great pull toy!", price: 10, image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg", inventory: 32)
      @dog_bone = @brian.items.create(name: "Dog Bone", description: "They'll love it!", price: 21, image: "https://img.chewy.com/is/image/catalog/54226_MAIN._AC_SL1500_V1534449573_.jpg", active?:false, inventory: 21)
    end

    it "all items or merchant names are links" do
      visit '/items'

      expect(page).to have_link(@tire.name)
      expect(page).to have_link(@tire.merchant.name)
      expect(page).to have_link(@pull_toy.name)
      expect(page).to have_link(@pull_toy.merchant.name)
      expect(page).to_not have_link(@dog_bone.name)
    end

    it "I can see a list of all active items and hide inactive items" do
      visit '/items'

      within "#item-#{@tire.id}" do
        expect(page).to have_link(@tire.name)
        expect(page).to have_content(@tire.description)
        expect(page).to have_content("Price: $#{@tire.price}")
        expect(page).to have_content("Inventory: #{@tire.inventory}")
        expect(page).to have_link(@meg.name)
        expect(page).to have_css("img[src*='#{@tire.image}']")
      end

      within "#item-#{@pull_toy.id}" do
        expect(page).to have_link(@pull_toy.name)
        expect(page).to have_content(@pull_toy.description)
        expect(page).to have_content("Price: $#{@pull_toy.price}")
        expect(page).to have_content("Inventory: #{@pull_toy.inventory}")
        expect(page).to have_link(@brian.name)
        expect(page).to have_css("img[src*='#{@pull_toy.image}']")
      end

      expect(page).to_not have_css("#item-#{@dog_bone.id}")
    end

    it "can click an image that links to item's show page" do
      visit '/items'

      within "#item-#{@tire.id}" do
        click_link("#{@tire.name}")
      end

      expect(current_path).to eq("/items/#{@tire.id}")
    end

    it "can see top 5 most popular and least popular items by quantity purchased, plus quantity bought" do
      tennis_ball = @brian.items.create(name: "Tennis Ball", description: "Bounces for days!", price: 21, image: "https://d0bb7f9bf11b5ad1a6b2-6175f06f5e3f64e15abbf67415a276ec.ssl.cf1.rackcdn.com/product-images/designlab/promotional-pet-toy-tennis-balls-gbttb-yellow1468478755.jpg", active?:true, inventory: 21)

      chew_toy = @brian.items.create(name: "Chew Toy", description: "Chews for days!", price: 21, image: "https://i5.walmartimages.com/asr/42ff43c6-1ba8-4061-bd67-656eee493086_1.5caa8bd92323ed8bc3e6d28b0a0cb0b9.png", active?:true, inventory: 21)

      flying_disc = @brian.items.create(name: "A Flying Disc", description: "Flies for days!", price: 10, image: "https://hw.menardc.com/main/items/media/CEGEN001/ProductLarge/253-0107_P_4.jpg", inventory: 32)

      user = User.create!(name: "bob", password: '12345', address: "street", city: "Denver", state: "CO", zip:"12345", email: "someone@gmail.com", role: 0)

      order = Order.create!(name: "name", address: "address", city: "city", state: "state", zip: 80210, user_id: user.id)
      order_2 = Order.create!(name: "name", address: "address", city: "city", state: "state", zip: 80210, user_id: user.id)

      ItemOrder.create!(order_id: order.id, price: 1.0, item_id: tennis_ball.id, quantity: 5)
      ItemOrder.create!(order_id: order.id, price: 1.0, item_id: @pull_toy.id, quantity: 1)
      ItemOrder.create!(order_id: order.id, price: 1.0, item_id: @tire.id, quantity: 4)
      ItemOrder.create!(order_id: order.id, price: 1.0, item_id: flying_disc.id, quantity: 3)
      ItemOrder.create!(order_id: order.id, price: 1.0, item_id: chew_toy.id, quantity: 2)
      ItemOrder.create!(order_id: order_2.id, price: 1.0, item_id: tennis_ball.id, quantity: 3)
      ItemOrder.create!(order_id: order_2.id, price: 1.0, item_id: @pull_toy.id, quantity: 4)

      visit "/items"

      within '#most-popular' do
        expect(page).to have_content("Top 5 Most Popular Items:")

        expect(tennis_ball.name).to appear_before(@pull_toy.name)
        expect(page).to have_content("Total purchased: 8")

        expect(@pull_toy.name).to appear_before(@tire.name)
        expect(page).to have_content("Total purchased: 5")

        expect(@tire.name).to appear_before(flying_disc.name)
        expect(page).to have_content("Total purchased: 4")

        expect(flying_disc.name).to appear_before(chew_toy.name)
        expect(page).to have_content("Total purchased: 3")
        expect(page).to have_content("Total purchased: 2")
      end

      within '#least-popular' do
        expect(page).to have_content("Top 5 Least Popular Items:")

        expect(chew_toy.name).to appear_before(flying_disc.name)
        expect(page).to have_content("Total purchased: 2")

        expect(flying_disc.name).to appear_before(@tire.name)
        expect(page).to have_content("Total purchased: 3")

        expect(@tire.name).to appear_before(@pull_toy.name)
        expect(page).to have_content("Total purchased: 4")

        expect(@pull_toy.name).to appear_before(tennis_ball.name)
        expect(page).to have_content("Total purchased: 5")
        expect(page).to have_content("Total purchased: 8")
      end
    end
  end
end
