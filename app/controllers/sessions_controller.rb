class SessionsController < ApplicationController
  rescue_from RaceCondition, with: :race_condition
  
  def create
    @user = Oauth::Authorization.new.authorize(auth_hash: auth_hash)
    UserUpdateWorker.perform_async(@user.login, true)
    flash[:info] = "Welcome #{@user.login}, your data is updating"
    session[:user_id] = @user.id
    redirect_to user_path(@user)
  end
  
  def failure
    flash[:alert] = params[:message]
    redirect_to '/'
  end
  
  protected

  def auth_hash
    request.env['omniauth.auth']
  end
  
  def race_condition
    flash[:alert] = "Your accound could not be updated, please try again"
    return redirect_to '/'
  end
end