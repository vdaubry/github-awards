require 'rails_helper'

describe "UserPresenter" do
  before(:each) do
    @user = FactoryGirl.create(:user, :city => "paris", :country => "france")

    FactoryGirl.create(:repository, :user => @user, :language => "ruby", :stars => 1)
    FactoryGirl.create(:repository, :user => @user, :language => "javascript", :stars => 2)
    FactoryGirl.create(:repository, :user => @user, :language => "ruby", :stars => 0)
    
    $redis.zadd("user_ruby_paris", 1.5, @user.id)
    $redis.zadd("user_javascript_paris", 2.0, @user.id)
    $redis.zadd("user_ruby_france", 1.5, @user.id)
    $redis.zadd("user_javascript_france", 2.0, @user.id)
    
    @presenter = UserPresenter.new(@user)
  end

  describe "best_rank_tweet" do
    it "returns language with best city rank" do
      @presenter.best_rank_tweet.should == "<p>Tweet your <a href='http://twitter.com/share?text=I am the top 1 javascript developer in Paris. Check your GitHub ranking on GitHub Awards !&url=http://localhost:5000/users/#{URI.encode(@user.login)}' title='Share GitHub Awards on Twitter' target='_blank'>ranking <i class='fa fa-twitter'></i></a></p>"
    end
    
    context "no ranking" do
      it "returns nil" do
         UserPresenter.new(FactoryGirl.create(:user)).best_rank_tweet.should == nil
      end
    end
    
    context "no city" do
      it "returns nil" do
        user = FactoryGirl.create(:user, :city => nil)
        FactoryGirl.create(:repository, :user => user, :language => "ruby", :stars => 1)
        $redis.zadd("user_ruby_paris", 1.0, user.id)
        UserPresenter.new(user).best_rank_tweet.should == nil
      end
    end
  end
end