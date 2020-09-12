class Merchant::DashboardController < ApplicationController
  def index
    merchant = User.find(session[:user_id])
    flash[:success] = "Hello, #{merchant.name}. You are now logged in."
  end
end
