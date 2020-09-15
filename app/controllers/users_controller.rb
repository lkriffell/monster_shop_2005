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
    if current_user
      @user = current_user
    else
      render file: "/public/404"
    end
  end

  def edit
  end

  def edit_password
  end

  def update
    current_user.attributes = user_params
    if current_user.save
      flash[:succes] = "Your information has been updated."
    else
      flash[:error] = current_user.errors.full_messages.uniq.to_sentence
    end
    redirect_to '/profile'
  end

  private
    def user_params
      params.permit(:name, :address, :city, :state, :zip, :email, :password, :password_confirmation)
    end
end
