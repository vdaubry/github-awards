class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  caches_action :about
  
  def welcome
  end
  
  def about
  end
  
  def not_found
    raise ActiveRecord::RecordNotFound.new('Not Found')
  end
end
