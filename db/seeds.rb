# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Merchant.destroy_all
Item.destroy_all

#merchants
bike_shop = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
dog_shop = Merchant.create(name: "Brian's Dog Shop", address: '125 Doggo St.', city: 'Denver', state: 'CO', zip: 80210)

#bike_shop items
tire = bike_shop.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)

#dog_shop items
pull_toy = dog_shop.items.create(name: "Pull Toy", description: "Great pull toy!", price: 10, image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg", inventory: 32)
dog_bone = dog_shop.items.create(name: "Dog Bone", description: "They'll love it!", price: 21, image: "https://img.chewy.com/is/image/catalog/54226_MAIN._AC_SL1500_V1534449573_.jpg", active?:false, inventory: 21)

tennis_ball = dog_shop.items.create(name: "Tennis Ball", description: "Bounces for days!", price: 21, image: "https://d0bb7f9bf11b5ad1a6b2-6175f06f5e3f64e15abbf67415a276ec.ssl.cf1.rackcdn.com/product-images/designlab/promotional-pet-toy-tennis-balls-gbttb-yellow1468478755.jpg", active?:true, inventory: 21)

chew_toy = dog_shop.items.create(name: "Chew Toy", description: "Chews for days!", price: 21, image: "https://i5.walmartimages.com/asr/42ff43c6-1ba8-4061-bd67-656eee493086_1.5caa8bd92323ed8bc3e6d28b0a0cb0b9.png", active?:true, inventory: 21)

flying_disc = dog_shop.items.create(name: "A Flying Disc", description: "Flies for days!", price: 10, image: "https://hw.menardc.com/main/items/media/CEGEN001/ProductLarge/253-0107_P_4.jpg", inventory: 32)

order = Order.create!(name: "name", address: "address", city: "city", state: "state", zip: 80210)
order_2 = Order.create!(name: "name", address: "address", city: "city", state: "state", zip: 80210)

ItemOrder.create!(order_id: order.id, price: 1.0, item_id: tennis_ball.id, quantity: 5)
ItemOrder.create!(order_id: order.id, price: 1.0, item_id: pull_toy.id, quantity: 1)
ItemOrder.create!(order_id: order.id, price: 1.0, item_id: tire.id, quantity: 4)
ItemOrder.create!(order_id: order.id, price: 1.0, item_id: flying_disc.id, quantity: 3)
ItemOrder.create!(order_id: order.id, price: 1.0, item_id: chew_toy.id, quantity: 2)
ItemOrder.create!(order_id: order_2.id, price: 1.0, item_id: tennis_ball.id, quantity: 3)
ItemOrder.create!(order_id: order_2.id, price: 1.0, item_id: pull_toy.id, quantity: 4)
