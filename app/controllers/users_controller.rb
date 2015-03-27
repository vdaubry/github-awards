class UsersController < ApplicationController
  def index
    @user_list_presenter = UserListPresenter.new(params)
  end
  
  def search
    show_user(params[:login].downcase.strip)
    rescue ActiveRecord::RecordNotFound => e
      redirect_to welcome_path, :alert => "User #{params[:login]} not found"
  end

  def show
    show_user(params[:id])
  end
  
  private 
  
  def show_user(login)
    @user = User.where(:login => login).first || not_found
    @user_presenter = UserPresenter.new(@user)
    render action: 'show'
  end
end
