require 'rails_helper'

describe Item, type: :model do
  describe "validations" do
    it { should validate_presence_of :name }
    it { should validate_presence_of :description }
    it { should validate_presence_of :price }
    it { should validate_presence_of :image }
    it { should validate_presence_of :inventory }
    it { should validate_inclusion_of(:active?).in_array([true,false]) }
  end

  describe "relationships" do
    it {should belong_to :merchant}
    it {should have_many :reviews}
    it {should have_many :item_orders}
    it {should have_many(:orders).through(:item_orders)}
  end

  describe 'class methods' do
    before(:each) do
      meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
      brian = Merchant.create(name: "Brian's Dog Shop", address: '125 Doggo St.', city: 'Denver', state: 'CO', zip: 80210)

      tire = meg.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
      pull_toy = brian.items.create(name: "Pull Toy", description: "Great pull toy!", price: 10, image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg", inventory: 32)
      @tennis_ball = brian.items.create(name: "Tennis Ball", description: "Bounces for days!", price: 21, image: "https://d0bb7f9bf11b5ad1a6b2-6175f06f5e3f64e15abbf67415a276ec.ssl.cf1.rackcdn.com/product-images/designlab/promotional-pet-toy-tennis-balls-gbttb-yellow1468478755.jpg", active?:true, inventory: 21)

      @chew_toy = brian.items.create(name: "Chew Toy", description: "Chews for days!", price: 21, image: "https://i5.walmartimages.com/asr/42ff43c6-1ba8-4061-bd67-656eee493086_1.5caa8bd92323ed8bc3e6d28b0a0cb0b9.png", active?:true, inventory: 21)

      flying_disc = brian.items.create(name: "A Flying Disc", description: "Flies for days!", price: 10, image: "https://hw.menardc.com/main/items/media/CEGEN001/ProductLarge/253-0107_P_4.jpg", inventory: 32)

      order = Order.create!(name: "name", address: "address", city: "city", state: "state", zip: 80210)
      order_2 = Order.create!(name: "name", address: "address", city: "city", state: "state", zip: 80210)

      ItemOrder.create!(order_id: order.id, price: 1.0, item_id: @tennis_ball.id, quantity: 5)
      ItemOrder.create!(order_id: order.id, price: 1.0, item_id: pull_toy.id, quantity: 1)
      ItemOrder.create!(order_id: order.id, price: 1.0, item_id: tire.id, quantity: 4)
      ItemOrder.create!(order_id: order.id, price: 1.0, item_id: flying_disc.id, quantity: 3)
      ItemOrder.create!(order_id: order.id, price: 1.0, item_id: @chew_toy.id, quantity: 2)
      ItemOrder.create!(order_id: order_2.id, price: 1.0, item_id: @tennis_ball.id, quantity: 3)
      ItemOrder.create!(order_id: order_2.id, price: 1.0, item_id: pull_toy.id, quantity: 4)
    end

    it 'sorts most popular' do
      expect(Item.items_by_popularity(5)[0].name).to eq(@tennis_ball.name)
      expect(Item.items_by_popularity(5)[0].total_quantity).to eq(8)
      expect(Item.items_by_popularity(5)[-1].name).to eq(@chew_toy.name)
      expect(Item.items_by_popularity(5)[-1].total_quantity).to eq(2)
    end

    it 'sorts least popular' do
      expect(Item.items_by_popularity(5, 'asc')[0].name).to eq(@chew_toy.name)
      expect(Item.items_by_popularity(5, 'asc')[0].total_quantity).to eq(2)
      expect(Item.items_by_popularity(5, 'asc')[-1].name).to eq(@tennis_ball.name)
      expect(Item.items_by_popularity(5, 'asc')[-1].total_quantity).to eq(8)
    end
  end

  describe "instance methods" do
    before(:each) do
      @bike_shop = Merchant.create(name: "Brian's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
      @chain = @bike_shop.items.create(name: "Chain", description: "It'll never break!", price: 50, image: "https://www.rei.com/media/b61d1379-ec0e-4760-9247-57ef971af0ad?size=784x588", inventory: 5)

      @review_1 = @chain.reviews.create(title: "Great place!", content: "They have great bike stuff and I'd recommend them to anyone.", rating: 5)
      @review_2 = @chain.reviews.create(title: "Cool shop!", content: "They have cool bike stuff and I'd recommend them to anyone.", rating: 4)
      @review_3 = @chain.reviews.create(title: "Meh place", content: "They have meh bike stuff and I probably won't come back", rating: 1)
      @review_4 = @chain.reviews.create(title: "Not too impressed", content: "v basic bike shop", rating: 2)
      @review_5 = @chain.reviews.create(title: "Okay place :/", content: "Brian's cool and all but just an okay selection of items", rating: 3)
    end

    it "calculate average review" do
      expect(@chain.average_review).to eq(3.0)
    end

    it "sorts reviews" do
      top_three = @chain.sorted_reviews(3,:desc)
      bottom_three = @chain.sorted_reviews(3,:asc)

      expect(top_three).to eq([@review_1,@review_2,@review_5])
      expect(bottom_three).to eq([@review_3,@review_4,@review_5])
    end

    it 'no orders' do
      expect(@chain.no_orders?).to eq(true)
      user = User.create!(name: "bob", password: '12345', address: "street", city: "Denver", state: "CO", zip:"12345", email: "someone@gmail.com", role: 0)
      order = Order.create(name: 'Meg', address: '123 Stang Ave', city: 'Hershey', state: 'PA', zip: 17033, user: user)
      order.item_orders.create(item: @chain, price: @chain.price, quantity: 2)
      expect(@chain.no_orders?).to eq(false)
    end
  end

  it '#inventory_has_reached_limit?(cart, item)' do
    @meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)

    @tire = @meg.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 3)

      @cart_1 = Cart.new({
        @tire.id.to_s => 1
        })
    expect(@tire.inventory_has_reached_limit?(@cart_1)).to eq(false)

      @cart_2 = Cart.new({
        @tire.id.to_s => 2
        })
    expect(@tire.inventory_has_reached_limit?(@cart_2)).to eq(false)

      @cart_3 = Cart.new({
        @tire.id.to_s => 3
        })
    expect(@tire.inventory_has_reached_limit?(@cart_3)).to eq(true)

  end
end
