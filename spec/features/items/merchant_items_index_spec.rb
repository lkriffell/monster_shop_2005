require 'rails_helper'

RSpec.describe "Merchant Items Index Page" do
  describe "When I visit the merchant items page" do
    before(:each) do
      @meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
      @tire = @meg.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
      @chain = @meg.items.create(name: "Chain", description: "It'll never break!", price: 50, image: "https://www.rei.com/media/b61d1379-ec0e-4760-9247-57ef971af0ad?size=784x588", inventory: 5)
      @shifter = @meg.items.create(name: "Shimano Shifters", description: "It'll always shift!", active?: false, price: 180, image: "https://images-na.ssl-images-amazon.com/images/I/4142WWbN64L._SX466_.jpg", inventory: 2)
    end

    it 'shows me a list of that merchants items' do
      visit "merchants/#{@meg.id}/items"

      within "#item-#{@tire.id}" do
        expect(page).to have_content(@tire.name)
        expect(page).to have_content("Price: $#{@tire.price}")
        expect(page).to have_css("img[src*='#{@tire.image}']")
        expect(page).to have_content("Active")
        expect(page).to have_content(@tire.description)
        expect(page).to have_content("Inventory: #{@tire.inventory}")
      end

      within "#item-#{@chain.id}" do
        expect(page).to have_content(@chain.name)
        expect(page).to have_content("Price: $#{@chain.price}")
        expect(page).to have_css("img[src*='#{@chain.image}']")
        expect(page).to have_content("Active")
        expect(page).to have_content(@chain.description)
        expect(page).to have_content("Inventory: #{@chain.inventory}")
      end

      within "#item-#{@shifter.id}" do
        expect(page).to have_content(@shifter.name)
        expect(page).to have_content("Price: $#{@shifter.price}")
        expect(page).to have_css("img[src*='#{@shifter.image}']")
        expect(page).to have_content("Inactive")
        expect(page).to have_content(@shifter.description)
        expect(page).to have_content("Inventory: #{@shifter.inventory}")
      end
    end
  end

  describe 'as a merchant' do
    before(:each) do
      @shop = create(:merchant)
      @employee = create(:merchant_user, merchant_id: @shop.id)
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@employee)
      @items = []
      3.times do
        @items << create(:item, merchant_id: @shop.id)
      end

      @other_shop = create(:merchant)
      @other_employee = create(:merchant_user, merchant_id: @other_shop.id)
      @other_items = []
      3.times do
        @other_items << create(:item, merchant_id: @other_shop.id)
      end
    end

    it 'I can only see my items' do
      visit "/merchant/items/#{@shop.id}"

      @items.each do |item|
        within("#item-#{item.id}") do
          expect(page).to have_content(item.name)
          expect(page).to have_content(item.description)
          expect(page).to have_content(item.price)
          expect(page).to have_css("img[src*='#{item.image}']")
          expect(page).to have_content('Active')
          expect(page).to have_content(item.inventory)
        end
      end

      @other_items.each do |other_item|
        expect(page).not_to have_css("#item-#{other_item.id}")
      end
    end

    it 'I can see deactivate links for my items' do
      visit "/merchant/items/#{@shop.id}"

      @items.each do |item|
        within("#item-#{item.id}") do
          expect(page).to have_content('Active')
          expect(page).to have_link('Deactivate')
        end
      end
    end

    it 'I can see deactivate links for my items' do
      @items.each do |item|
        item.update(active?: false)
        visit "/merchant/items/#{@shop.id}"
        expect(page).to have_content('Inactive')
        expect(page).to have_link('Activate')
      end
    end

    it 'I can deactivate/activate an item' do
      visit "/merchant/items/#{@shop.id}"

      item = @items[0]

      within("#item-#{item.id}") do
        click_link 'Deactivate'
      end

      expect(current_path).to eq("/merchant/items/#{@shop.id}")
      expect(page).to have_content("#{item.name} is now inactive.")

      within("#item-#{item.id}") do
        expect(page).to have_content('Inactive')
        click_link 'Activate'
      end

      expect(current_path).to eq("/merchant/items/#{@shop.id}")
      expect(page).to have_content("#{item.name} is now active.")
    end

    it "I can delete an item that has never been ordered" do
      visit "/merchant/items/#{@shop.id}"

      user = create(:user)
      unordered_item = @items.pop
      order = create(:order, user_id: user.id)

      @items.each do |item|
        create(:item_order, order_id: order.id, item_id: item.id, price: item.price)

        visit "/merchant/items/#{@shop.id}"

        within("#item-#{item.id}") do
          expect(page).not_to have_link("Delete")
        end
      end

      within("#item-#{unordered_item.id}") do
        click_link("Delete")
      end

      expect(current_path).to eq("/merchant/items/#{@shop.id}")
      expect(page).not_to have_css("#item-#{unordered_item.id}")
    end
  end
end
