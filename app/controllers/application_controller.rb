class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  helper_method :cart

  def cart
    @cart ||= Cart.new(session[:cart] ||= Hash.new(0))
  end

  def current_user
    if session[:user_id]
      User.find(session[:user_id])
    end
  end

  def current_admin?
    current_user && current_user.admin?
  end

  def current_merchant?
    current_user && current_user.merchant?
  end
end
