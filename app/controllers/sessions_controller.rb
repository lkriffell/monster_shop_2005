class SessionsController < ApplicationController
  def new
    if current_user
      flash[:success] = "You are already logged in."
      redirect_user(current_user)
    end
  end

  def create
    user = User.find_by(email: session_params[:email])
    if user && user.authenticate(session_params[:password])
      session[:user_id] = user.id
      flash[:success] = "Hello, #{user.name}. You are now logged in."
      redirect_user(user)
    else
      flash[:error] = "Sorry, your credentials are incorrect."
      render :new
    end
  end

  def redirect_user(user)
    if user.merchant?
      redirect_to '/merchant/dashboard'
    elsif user.admin?
      redirect_to '/admin/dashboard'
    else
      redirect_to '/profile'
    end
  end

  def destroy
    session[:user_id] = nil
    session[:cart] = {}
    flash[:success] = "You are now logged out."
    redirect_to '/'
  end

  private
  def session_params
    params.permit(:email, :password)
  end
end
