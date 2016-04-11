class UsersController < ApplicationController
  before_action :logged_in_user, only: [:index, :edit, :update]
  before_action :correct_user,   only: [:edit, :update]
  before_action :admin_user,     only: :destroy

  def index
    @users = User.paginate(:page => params[:page], :per_page => 5)
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      log_in @user
      flash[:success] = "Welcome to ToiletPal!"
      redirect_to @user
    else
      @errors = @user.errors.full_messages
      flash[:error] = "You did not enter a valid reponse!"
      render 'users/new'
    end
  end

  def show
    @user = User.find(params[:id])
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      @errors = @user.errors.full_messages
      flash[:error] = "You did not enter a valid reponse!"
      render 'users/edit'
    end
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User deleted"
    redirect_to users_path
  end

  private

  def user_params
    params.require(:user).permit(:username, :email, :password, :password_confirmation, :first_name, :last_name, :gender, :zip_code)
  end

  def logged_in_user
    unless logged_in?
      flash[:danger] = "Please log in."
      redirect_to login_path
    end
  end

  def correct_user
    @user = User.find(params[:id])
    redirect_to(root_path) unless @user == current_user
  end

  def admin_user
    redirect_to(root_path) unless current_user.admin?
  end

end
