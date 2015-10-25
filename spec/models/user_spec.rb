require 'rails_helper'

describe "User" do
  let(:user) { FactoryGirl.create(:user) }

  describe "new" do
    it { expect(FactoryGirl.build(:user, login: nil).save).to eq(false) }
    it { expect(FactoryGirl.build(:user).save).to eq(true) }
  end
  
  describe "save" do
    it "downcase login before save" do
      user = FactoryGirl.build(:user, login: "ABC")
      user.save
      expect(user.reload.login).to eq("abc") 
    end 
  end
  
  describe "repositories"  do
    it "has many repositories" do
      FactoryGirl.create_list(:repository, 2, user: user)
      expect(user.reload.repositories.count).to eq(2)
    end
  end

  describe "associations" do
    it "cascades deletes repositories" do
      FactoryGirl.create_list(:repository, 2, user: user)
      user.destroy
      expect(Repository.count).to eq(0)
    end

    it "cascades deletes authentication_providers" do
      FactoryGirl.create_list(:authentication_provider, 2, user: user)
      user.destroy
      expect(AuthenticationProvider.count).to eq(0)
    end
  end
  
  describe "unique fields" do
    before(:each) do
      FactoryGirl.create(:user, login: "foo")
    end
    
    it "allows different login" do
      expect(FactoryGirl.build(:user, login: "bar").save).to eq(true)
    end
    
    it "forbids duplicates login" do
      expect(FactoryGirl.build(:user, login: "foo").save).to eq(false)
    end
  end
  
  describe "user_ranks" do

    
    it "returns ordered user_ranks" do
      FactoryGirl.create(:repository, language: "ruby", user: user, stars: 2)
      FactoryGirl.create(:repository, language: "javascript", user: user, stars: 3)
      FactoryGirl.create(:repository, language: nil, user: user, stars: 1)
      
      user_ranks = user.user_ranks
      expect(user_ranks.count).to eq(2)
      
      expect(user_ranks[0].language).to eq("javascript")
      expect(user_ranks[0].stars_count).to eq(3)
      expect(user_ranks[0].repository_count).to eq(1)
      
      expect(user_ranks[1].language).to eq("ruby")
      expect(user_ranks[1].stars_count).to eq(2)
      expect(user_ranks[1].repository_count).to eq(1)
    end
    
    it "ignores repo without languages" do
      FactoryGirl.create(:repository, language: "ruby", user: user, stars: 2)
      FactoryGirl.create(:repository, language: nil, user: user, stars: 3)
      expect(user.user_ranks.count).to eq(1)
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