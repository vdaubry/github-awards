require 'rails_helper'

describe "UserRankPresenter" do
  describe "city_infos" do
    context "city present" do
      it "returns city ranking" do
        user = FactoryGirl.create(:user, city: "paris")
        $redis.zadd("user_ruby_paris", 1, user.id)
        user_rank = UserRank.new(user, "ruby", 7, 2)
        expect(UserRankPresenter.new(user_rank).city_infos).to eq("<td class=\"col-md-3\"><a href=\"/users?city=paris&amp;language=ruby\">Paris</a></td><td><strong>1</strong> / 1 <i class='fa fa-trophy'></i></td>")
      end
    end
    context "city missing" do
      it "returns missing city message" do
        user_rank = UserRank.new(FactoryGirl.create(:user, city: nil), "ruby", 7, 2)
        expect(UserRankPresenter.new(user_rank).city_infos).to eq("<td colspan=\"2\"><p>We couldn't find your city from your location on GitHub :( </p><p>You can manually search for <a href=\"/users?language=ruby\">top Ruby GitHub developers in your city</a></p></td>")
      end
    end
  end
  
  describe "country_infos" do
    context "country present" do
      it "returns country ranking" do
        user = FactoryGirl.create(:user, country: "france")
        $redis.zadd("user_ruby_france", 1, user.id)
        user_rank = UserRank.new(user, "ruby", 7, 2)
        expect(UserRankPresenter.new(user_rank).country_infos).to eq("<td class=\"col-md-3\"><a href=\"/users?country=france&amp;language=ruby\">France</a></td><td><strong>1</strong> / 1 <i class='fa fa-trophy'></i></td>")
      end
    end
    context "country missing" do
      it "returns nil" do
        user_rank = UserRank.new(FactoryGirl.create(:user, country: nil), "ruby", 7, 2)
        expect(UserRankPresenter.new(user_rank).country_infos).to eq(nil)
      end
    end
  end
  
  describe "world_infos" do
    it "returns world ranking" do
      user = FactoryGirl.create(:user)
      $redis.zadd("user_ruby", 1, user.id)
      user_rank = UserRank.new(user, "ruby", 7, 2)
      expect(UserRankPresenter.new(user_rank).world_infos).to eq("<td class=\"col-md-3\"><a href=\"/users?language=ruby\">Worldwide</a></td><td><strong>1</strong> / 1 <i class='fa fa-trophy'></i></td>")
    end
  end
end