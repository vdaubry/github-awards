class UsersController < ApplicationController
  def index
    @user_list_presenter = UserListPresenter.new(params)
  end
  
  def search
    show_user(params[:login])
    rescue ActiveRecord::RecordNotFound => e
      redirect_to welcome_path, alert: "User #{ERB::Util.html_escape params[:login]} not found. If you are looking for your own profile you can <a href='/auth/github'>refresh it from Github</a>"
  end

  def show
    show_user(params[:id])
  end
  
  private 
  
  def show_user(login)
    @user = User.where(login: login.try(:downcase).try(:strip)).first || not_found
    
    @user_presenter = UserPresenter.new(@user)
    render action: 'show'
  end
end
