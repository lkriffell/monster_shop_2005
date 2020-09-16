require 'rails_helper'

RSpec.describe "admin" do
  describe "can see all merchants through the all merchants page" do
    it "and can disable a merchant as well as their items" do
      admin = User.create!(name: "bob", password: '12345', password_confirmation: '12345', address: "street", city: "Denver", state: "CO", zip:"12345", email: "someone@gmail.com", role: 2)
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(admin)

      5.times do
        shop = create(:merchant)
        item = create(:item, merchant_id: shop.id)
        item = create(:item, merchant_id: shop.id)
      end
      merchant1 = Merchant.all.first
      merchant2 = Merchant.all.last

      visit '/'

      click_link 'All Merchants'

      expect(page).to have_content(merchant1.name)
      expect(page).to have_content(merchant2.name)

      within "#merchant#{merchant1.id}" do
        click_link "Disable Merchant"
      end

      expect(page).to have_content("#{merchant1.name} has been disabled.")
      expect(current_path).to eq('/admin/merchants')

      item_statuses = merchant1.items.pluck(:active?).uniq
      expect(item_statuses).to eq([false])
    end

    it "and can enable a merchant as well as their items" do
      admin = User.create!(name: "bob", password: '12345', password_confirmation: '12345', address: "street", city: "Denver", state: "CO", zip:"12345", email: "someone@gmail.com", role: 2)
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(admin)

      merchant1 = create(:merchant)
      create(:item, merchant_id: merchant1.id)
      create(:item, merchant_id: merchant1.id)

      visit '/'

      click_link 'All Merchants'

      within "#merchant#{merchant1.id}" do
        click_link "Disable Merchant"
      end
      item_statuses = merchant1.items.pluck(:active?).uniq
      expect(item_statuses).to eq([false])

      expect(page).to have_content("#{merchant1.name} has been disabled.")

      expect(current_path).to eq('/admin/merchants')

      within "#merchant#{merchant1.id}" do
        click_link("Enable Merchant")
      end

      expect(page).to have_content("#{merchant1.name} has been enabled.")

      item_statuses = merchant1.items.pluck(:active?).uniq
      expect(item_statuses).to eq([true])
    end
  end
end
