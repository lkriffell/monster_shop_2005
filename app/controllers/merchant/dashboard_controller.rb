class Merchant::DashboardController < Merchant::BaseController
  def index
      current_user
      @merchant = Merchant.find(current_user.merchant_id)
      @orders = @merchant.orders.joins(:item_orders)
  end
end
