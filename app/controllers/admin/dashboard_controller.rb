class Admin::DashboardController < Admin::BaseController
  def index
  end

  def show_users
    @users = User.all
  end

  def show_merchants
    @enabled_merchants = Merchant.where(status: 1)
    @disabled_merchants = Merchant.where(status: 0)
  end

  def disable_merchant
    @merchant = Merchant.find(params[:id])
    @merchant.update(status: 0)
    @merchant.items.update(active?: false)
    flash[:success] = "#{@merchant.name} has been disabled."
    redirect_to '/admin/merchants'
  end

  def enable_merchant
    @merchant = Merchant.find(params[:id])
    @merchant.update(status: 1)
    @merchant.items.update(active?: true)
    flash[:success] = "#{@merchant.name} has been enabled."
    redirect_to '/admin/merchants'
  end
end
