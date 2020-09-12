class UsersController < ApplicationController
  def new
    @user_params = user_params
  end

  def create
    @user = User.new(user_params)
    if @user.save
      session[:user_id] = @user.id
      flash[:notice] = "You are now registered and logged in."
      redirect_to '/profile'
    else
      flash[:notice] = @user.errors.full_messages.uniq.to_sentence
      @user_params = user_params
      render :new
    end
  end

  def show
    @user = User.find(session[:user_id])
  end

  private
    def user_params
      params.permit(:name, :address, :city, :state, :zip, :email, :password, :password_confirmation)
    end
end
