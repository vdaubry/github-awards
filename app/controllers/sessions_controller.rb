class SessionsController < ApplicationController
  def create
    @user = Oauth::Authorization.new.authorize(auth_hash: auth_hash)
    UserUpdateWorker.perform_async(@user.login)
    flash[:info] = "Welcome #{@user.login}, your data are updating"
    session[:user_id] = @user.id
    redirect_to user_path(@user)
  end
  
  protected

  def auth_hash
    request.env['omniauth.auth']
  end
end