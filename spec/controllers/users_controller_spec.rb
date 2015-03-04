# encoding: utf-8
require 'rails_helper'

describe UsersController do
  
  let(:user) { FactoryGirl.create(:user, :login => "vdaubry") }
  let(:language_ranks) { FactoryGirl.create_list(:language_rank, 2, :user => user) }
  
  describe "GET show" do
    context "user exists" do
      it "sets user" do
        user
        get :show, :id => "vdaubry"
        assigns(:user).should == user
      end
      
      it "sets language_ranks" do
        language_ranks
        get :show, :id => "vdaubry"
        assigns(:language_ranks).count.should == 2
      end
    end
    
    context "user doesn't exists" do
      it "returns 404" do
        expect {
          get :show, :id => "vdaubry"
        }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end
  
  describe "GET search" do
    context "user exists" do
      it "sets user" do
        user
        get :search, :login => "vdaubry"
        assigns(:user).should == user
      end
      
      it "sets language_ranks" do
        language_ranks
        get :search, :login => "vdaubry"
        assigns(:language_ranks).count.should == 2
      end
      
      it "search case insensitive" do
        user
        get :search, :login => "Vdaubry"
        assigns(:user).should == user
      end

      it "search trim whitespace" do
        user
        get :search, :login => " Vdaubry "
        assigns(:user).should == user
      end
    end
    
    context "user doesn't exists" do
      it "redirects to users index" do
        get :search, :login => "vdaubry"
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