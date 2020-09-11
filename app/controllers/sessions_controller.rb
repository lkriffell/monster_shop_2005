class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email: session_params[:email])
    session[:user_id] = user.id
    flash[:success] = "Hello, #{user.name}. You are now logged in."
    redirect_to '/profile'
  end

  private
  def session_params
    params.permit(:email)
  end
end
