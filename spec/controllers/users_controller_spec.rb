# encoding: utf-8
require 'rails_helper'

describe UsersController do
render_views
  
  before(:each) do
    @user = FactoryGirl.create(:user, :login => "vdaubry", :city => "paris", :country => "france")
  end
  
  describe "GET show" do
    context "user exists" do
      it "sets user" do
        get :show, :id => "vdaubry"
        assigns(:user).should == @user
      end
      
      it "is case insensitive" do
        get :show, :id => "VDAUBRY"
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
    
    context "country as city" do
      it "should not fail" do
        user = FactoryGirl.create(:user, :city => nil, :country => "france")
        FactoryGirl.create(:repository, :language => "ruby", :user => user)
        $redis.zadd("user_ruby_france", 1.1, user.id)
        get :index, :city => "france", :language => "ruby", :type => "city"
        response.code.should == "200"
      end
    end
    
    context "invalid type" do
      it "should not fail" do
        get :index, :type => "foo"
        response.code.should == "200"
      end
    end
  end
end