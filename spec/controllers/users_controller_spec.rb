# encoding: utf-8
require 'rails_helper'

describe UsersController do
render_views
  
  before(:each) do
    @user = FactoryGirl.create(:user, :login => "vdaubry", :city => "paris", :country => "france")
    FactoryGirl.create(:repository, :language => "ruby", :user_id => @user.login)
    FactoryGirl.create(:repository, :language => "javascript", :user_id => @user.login)
    $redis.zadd("rank_paris_ruby", 1.1, @user.id)
    $redis.zadd("rank_france_ruby", 1.1, @user.id)
    $redis.zadd("rank_ruby", 1.1, @user.id)
    $redis.zadd("rank_paris_javascript", 1.1, @user.id)
    $redis.zadd("rank_france_javascript", 1.1, @user.id)
    $redis.zadd("rank_javascript", 1.1, @user.id)
  end
  
  
  describe "GET show" do
    context "user exists" do
      it "sets user" do
        get :show, :id => "vdaubry"
        assigns(:user).should == @user
      end
    end
    
    context "user doesn't exists" do
      it "returns 404" do
        expect {
          get :show, :id => "foobar"
        }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end
  
  describe "GET search" do
    context "user exists" do
      it "sets user" do
        get :search, :login => "vdaubry"
        assigns(:user).should == @user
      end
      
      it "search case insensitive" do
        get :search, :login => "Vdaubry"
        assigns(:user).should == @user
      end

      it "search trim whitespace" do
        get :search, :login => " vdaubry "
        assigns(:user).should == @user
      end
    end
    
    context "user doesn't exists" do
      it "redirects to users index" do
        get :search, :login => "foobar"
        response.should redirect_to(welcome_path)
      end
    end
    
    context "empty user" do
      it "redirects to users index" do
        get :search
        response.should redirect_to(welcome_path)
      end
    end
  end
  
  describe "GET index" do
    it "returns presenter" do
      get :index, :city => "Paris", :language => "Ruby", :type => "city"
      assigns(:user_list_presenter).should_not == nil
    end
  end
end