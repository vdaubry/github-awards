require 'rails_helper'

describe "User" do
  let(:user) { FactoryGirl.create(:user) }

  describe "new" do
    it { FactoryGirl.build(:user, login: nil).save.should == false }
    it { FactoryGirl.build(:user).save.should == true }
  end
  
  describe "save" do
    it "downcase login before save" do
      user = FactoryGirl.build(:user, login: "ABC")
      user.save
      user.reload.login.should == "abc" 
    end 
  end
  
  describe "repositories"  do
    it "has many repositories" do
      FactoryGirl.create_list(:repository, 2, user: user)
      user.reload.repositories.count.should == 2
    end
  end

  describe "associations" do
    it "cascades deletes repositories" do
      FactoryGirl.create_list(:repository, 2, user: user)
      user.destroy
      Repository.count.should == 0
    end

    it "cascades deletes authentication_providers" do
      FactoryGirl.create_list(:authentication_provider, 2, user: user)
      user.destroy
      AuthenticationProvider.count.should == 0
    end
  end
  
  describe "unique fields" do
    before(:each) do
      FactoryGirl.create(:user, login: "foo")
    end
    
    it "allows different login" do
      FactoryGirl.build(:user, login: "bar").save.should == true
    end
    
    it "forbids duplicates login" do
      FactoryGirl.build(:user, login: "foo").save.should == false
    end
  end
  
  describe "user_ranks" do

    
    it "returns ordered user_ranks" do
      FactoryGirl.create(:repository, language: "ruby", user: user, stars: 2)
      FactoryGirl.create(:repository, language: "javascript", user: user, stars: 3)
      FactoryGirl.create(:repository, language: nil, user: user, stars: 1)
      
      user_ranks = user.user_ranks
      user_ranks.count.should == 2
      
      user_ranks[0].language.should == "javascript"
      user_ranks[0].stars_count.should == 3
      user_ranks[0].repository_count.should == 1
      
      user_ranks[1].language.should == "ruby"
      user_ranks[1].stars_count.should == 2
      user_ranks[1].repository_count.should == 1
    end
    
    it "ignores repo without languages" do
      FactoryGirl.create(:repository, language: "ruby", user: user, stars: 2)
      FactoryGirl.create(:repository, language: nil, user: user, stars: 3)
      user.user_ranks.count.should == 1
    end
  end

  describe "remove_ranks" do
    it "remove a user from ranking" do
      FactoryGirl.create(:repository, language: "ruby", user: user, stars: 2)
      $redis.zadd("user_ruby_paris", 3.2, user.id)
      $redis.zadd("user_ruby_france", 3.8, user.id)
      $redis.zadd("user_ruby", 1.1, 1234)

      user.remove_ranks
      $redis.keys == nil
    end
  end
end