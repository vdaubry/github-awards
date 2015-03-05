require "rails_helper"

describe TopRank do
  describe "user_ranks" do
    before(:each) do
      @user1 = FactoryGirl.create(:user, :city => "paris")
      FactoryGirl.create(:repository, :language => "ruby", :user => @user1, :stars => 1)
      
      @user2 = FactoryGirl.create(:user, :city => "paris")
      FactoryGirl.create(:repository, :language => "ruby", :user => @user2, :stars => 2)
      
      @user3 = FactoryGirl.create(:user, :city => "paris")
      FactoryGirl.create(:repository, :language => "ruby", :user => @user3, :stars => 3)
      
      $redis.zadd("user_paris_ruby", 1.1, @user1.id)
      $redis.zadd("user_paris_ruby", 5.0, @user2.id)
      $redis.zadd("user_paris_ruby", 0.2, @user3.id)
    end
    
    it "returns asked number of result" do
      user_ranks = TopRank.new(type: "city", language: "ruby", location: "paris").user_ranks(page: 0, per: 2)
      user_ranks.count.should == 2
    end
    
    it "returns users ordered by rank" do
      user_ranks = TopRank.new(type: "city", language: "ruby", location: "paris").user_ranks(page: 0, per: 3)
      user_ranks[0].user.id.should == @user2.id
      user_ranks[1].user.id.should == @user1.id
      user_ranks[2].user.id.should == @user3.id
    end
    
    it "returns stars_count" do
      user_ranks = TopRank.new(type: "city", language: "ruby", location: "paris").user_ranks(page: 0, per: 1)
      user_ranks[0].user.stars_count.should == 2
    end
    
    it "returns repository_count" do
      user_ranks = TopRank.new(type: "city", language: "ruby", location: "paris").user_ranks(page: 0, per: 1)
      user_ranks[0].user.repository_count.should == 1
    end
  end
end