class Merchant::DashboardController < Merchant::BaseController
  def index
      user = current_user
      @merchant = Merchant.find(user.merchant_id)
      @orders = @merchant.orders.joins(:item_orders)
  end
end
