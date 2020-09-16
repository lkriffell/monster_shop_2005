require 'rails_helper'

RSpec.describe "As a merchant" do
  describe 'when I visit the merchant items index page' do
    before(:each) do
      @shop = create(:merchant)
      @employee = create(:merchant_user, merchant_id: @shop.id)
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@employee)
      @items = []
      3.times do
        @items << create(:item, merchant_id: @shop.id)
      end
    end

    it "I can add an item" do
      visit "/merchant/items/#{@shop.id}"

      click_link "Add Item"

      expect(current_path).to eq("/merchant/items/#{@shop.id}/new")

      
    end
  end
end
