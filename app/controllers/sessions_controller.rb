class SessionsController < ApplicationController
  def new
    if session[:user_id] != nil
      flash[:success] = "You are already logged in."
      user = User.find(session[:user_id])
      if user.role == 'default'
        redirect_to '/profile'
      elsif user.role == 'admin'
        redirect_to '/admin/dashboard'
      elsif user.role == 'merchant'
        redirect_to '/merchant/dashboard'
      end
    end
  end

  def create
    user = User.find_by(email: params[:email])
    if user.authenticate(params[:password])
      session[:user_id] = user.id
      flash[:success] = "Welcome, #{user.name}!"

      if user.role == "default"
        redirect_to '/profile'
      elsif user.role == "admin"
        redirect_to '/admin/dashboard'
      elsif user.role == "merchant"
        redirect_to '/merchant/dashboard'
      end
    else
      flash[:error] = "Sorry, your credentials are bad."
      redirect_to '/login'
    end
  end

  def destroy
    flash[:success] = "You are now logged out."
    session[:user_id] = nil
    session[:cart] = nil
    redirect_to '/'
  end
end
