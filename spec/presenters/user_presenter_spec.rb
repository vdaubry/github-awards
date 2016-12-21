require 'rails_helper'

describe "UserPresenter" do
  before(:each) do
    @user = FactoryGirl.create(:user, city: "paris", country: "france")

    FactoryGirl.create(:repository, user: @user, language: "ruby", stars: 1)
    FactoryGirl.create(:repository, user: @user, language: "javascript", stars: 2)
    FactoryGirl.create(:repository, user: @user, language: "ruby", stars: 0)
    
    $redis.zadd("user_ruby_paris", 1.5, @user.id)
    $redis.zadd("user_javascript_paris", 2.0, @user.id)
    $redis.zadd("user_ruby_france", 1.5, @user.id)
    $redis.zadd("user_javascript_france", 2.0, @user.id)
    
    @presenter = UserPresenter.new(@user)
  end

  describe "best_rank_tweet" do
    it "returns language with best city rank" do
      expect(@presenter.best_rank_tweet).to eq("<p>Tweet your <a target=\"_blank\" title=\"Share Git Awards on Twitter\" href=\"http://twitter.com/share?text=I am the top 1 javascript developer in Paris. Check your GitHub ranking on Git Awards !&amp;url=http://localhost:5000/users/#{URI.encode(@user.login)}\">ranking <i class='fa fa-twitter'></i></a></p>")
    end
    
    context "no ranking" do
      it "returns nil" do
         expect(UserPresenter.new(FactoryGirl.create(:user)).best_rank_tweet).to eq(nil)
      end
    end
    
    context "no city" do
      it "returns nil" do
        user = FactoryGirl.create(:user, city: nil)
        FactoryGirl.create(:repository, user: user, language: "ruby", stars: 1)
        $redis.zadd("user_ruby_paris", 1.0, user.id)
        expect(UserPresenter.new(user).best_rank_tweet).to eq(nil)
      end
    end
  end
end