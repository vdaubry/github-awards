class UsersController < ApplicationController
  caches_action :index, :search, :show, :cache_path => Proc.new { |c| c.params }
  
  def index
    @user_list_presenter = UserListPresenter.new(params)
  end
  
  def search
    show_user(params[:login])
    rescue ActiveRecord::RecordNotFound => e
      redirect_to welcome_path, :alert => "User #{params[:login]} not found"
  end

  def show
    show_user(params[:id])
  end
  
  private 
  
  def show_user(login)
    @user = User.where(:login => login).first || not_found
    @language_ranks = @user.language_ranks.order("stars_count DESC")
    @presenter = LanguageRankPresenter.new(@language_ranks)
    render action: 'show'
  end
end
