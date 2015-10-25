# encoding: utf-8
require 'rails_helper'

describe UsersController do
render_views
  
  before(:each) do
    @user = FactoryGirl.create(:user, login: "vdaubry", city: "paris", country: "france")
  end
  
  describe "GET show" do
    context "user exists" do
      it "sets user" do
        get :show, id: "vdaubry"
        expect(assigns(:user)).to eq(@user)
      end
      
      it "is case insensitive" do
        get :show, id: "VDAUBRY"
        expect(assigns(:user)).to eq(@user)
      end
    end
    
    context "user doesn't exists" do
      it "returns 404" do
        expect {
          get :show, id: "foobar"
        }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end
  
  describe "GET search" do
    context "user exists" do
      it "sets user" do
        get :search, login: "vdaubry"
        expect(assigns(:user)).to eq(@user)
      end
      
      it "search case insensitive" do
        get :search, login: "Vdaubry"
        expect(assigns(:user)).to eq(@user)
      end

      it "search trim whitespace" do
        get :search, login: " vdaubry "
        expect(assigns(:user)).to eq(@user)
      end
    end
    
    context "user doesn't exists" do
      it "redirects to users index" do
        get :search, login: "foobar"
        expect(response).to redirect_to(welcome_path)
      end
    end
    
    context "empty user" do
      it "redirects to users index" do
        get :search
        expect(response).to redirect_to(welcome_path)
      end
    end
  end
  
  describe "GET index" do
    it "returns presenter" do
      get :index, city: "Paris", language: "Ruby", type: "city"
      expect(assigns(:user_list_presenter)).not_to eq(nil)
    end
    
    context "country as city" do
      it "should not fail" do
        user = FactoryGirl.create(:user, city: nil, country: "france")
        FactoryGirl.create(:repository, language: "ruby", user: user)
        $redis.zadd("user_ruby_france", 1.1, user.id)
        get :index, city: "france", language: "ruby", type: "city"
        expect(response.code).to eq("200")
      end
    end
    
    context "invalid type" do
      it "should not fail" do
        get :index, type: "foo"
        expect(response.code).to eq("200")
      end
    end
  end
end