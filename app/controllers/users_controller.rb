class UsersController < ApplicationController
  def new
  end

  def create
    @user = User.new(user_params)
    require "pry"; binding.pry
    if @user.save
      session[:user_id] = @user.id
      flash[:notice] = "You are now registered and logged in."
      redirect_to '/profile'
    else
      flash[:notice] = "You must fill out all fields to register."
      render :new
    end
  end

  def show
    @user = User.find(session[:user_id])
  end

  private
    def user_params
      params.permit(:username, :address, :city, :state, :zip, :email, :password)
    end
end
