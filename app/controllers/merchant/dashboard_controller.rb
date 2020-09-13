class Merchant::DashboardController < Merchant::BaseController
  def index
    user = User.find(session[:user_id])
    @merchant = Merchant.find(user.merchant_id)
    @orders = @merchant.orders
    
    require "pry"; binding.pry
  end
end
