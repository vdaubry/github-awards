require "rails_helper"

describe TopRank do
  describe "user_ranks" do
    before(:each) do
      @user1 = FactoryGirl.create(:user, city: "paris")
      FactoryGirl.create(:repository, language: "ruby", user: @user1, stars: 1)
      
      @user2 = FactoryGirl.create(:user, city: "paris")
      FactoryGirl.create(:repository, language: "ruby", user: @user2, stars: 2)
      
      @user3 = FactoryGirl.create(:user, city: "paris")
      FactoryGirl.create(:repository, language: "ruby", user: @user3, stars: 3)
      
      $redis.zadd("user_ruby_paris", 1.1, @user1.id)
      $redis.zadd("user_ruby_paris", 5.0, @user2.id)
      $redis.zadd("user_ruby_paris", 0.2, @user3.id)
    end
    
    it "returns asked number of result" do
      user_ranks = TopRank.new(type: "city", language: "ruby", location: "paris").user_ranks(page: 1, per: 2)
      expect(user_ranks.count).to eq(2)
    end
    
    it "returns users ordered by rank" do
      user_ranks = TopRank.new(type: "city", language: "ruby", location: "paris").user_ranks(page: 1, per: 3)
      expect(user_ranks[0].user.id).to eq(@user2.id)
      expect(user_ranks[1].user.id).to eq(@user1.id)
      expect(user_ranks[2].user.id).to eq(@user3.id)
    end
    
    it "returns stars_count" do
      user_ranks = TopRank.new(type: "city", language: "ruby", location: "paris").user_ranks(page: 1, per: 1)
      expect(user_ranks[0].user.stars_count).to eq(2)
    end
    
    it "returns repository_count" do
      user_ranks = TopRank.new(type: "city", language: "ruby", location: "paris").user_ranks(page: 1, per: 1)
      expect(user_ranks[0].user.repository_count).to eq(1)
    end
    
    context "location not found" do
      it "returns empty result" do
        user_ranks = TopRank.new(type: "city", language: "ruby", location: "foo").user_ranks(page: 1, per: 2)
        expect(user_ranks.count).to eq(0)
      end
    end
  end
end