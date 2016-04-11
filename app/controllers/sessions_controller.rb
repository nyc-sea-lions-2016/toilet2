class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(username: params[:session][:username].downcase)
    if user && user.authenticate(params[:session][:password])
      session[:user_id] = user.id
      flash[:success] = "You've logged in successfully!"
      redirect_to user
    else
      flash.now[:danger] = 'Invalid username/password combination'
      redirect_to 'new'
    end
  end

  def destroy
    log_out
    redirect_to root_path
  end
end
