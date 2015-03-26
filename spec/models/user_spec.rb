require 'rails_helper'

describe "User" do
  
  describe "new" do
    it { FactoryGirl.build(:user, :login => nil).save.should == false }
    it { FactoryGirl.build(:user).save.should == true }
  end
  
  describe "save" do
    it "downcase login before save" do
      user = FactoryGirl.build(:user, :login => "ABC")
      user.save
      user.reload.login.should == "abc" 
    end 
  end
  
  describe "repositories"  do
    it "has many repositories" do
      user = FactoryGirl.create(:user)
      FactoryGirl.create_list(:repository, 2, :user => user)
      user.reload.repositories.count.should == 2
    end
  end
  
  
  describe "unique fields" do
    before(:each) do
      FactoryGirl.create(:user, :login => "foo")
    end
    
    it "allows different login" do
      FactoryGirl.build(:user, :login => "bar").save.should == true
    end
    
    it "forbids duplicates login" do
      FactoryGirl.build(:user, :login => "foo").save.should == false
    end
  end
  
  describe "user_ranks" do
    let(:user) { FactoryGirl.create(:user) }
    
    it "returns ordered user_ranks" do
      FactoryGirl.create(:repository, :language => "ruby", :user => user, :stars => 2)
      FactoryGirl.create(:repository, :language => "javascript", :user => user, :stars => 3)
      FactoryGirl.create(:repository, :language => nil, :user => user, :stars => 1)
      
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
      FactoryGirl.create(:repository, :language => "ruby", :user => user, :stars => 2)
      FactoryGirl.create(:repository, :language => nil, :user => user, :stars => 3)
      user.user_ranks.count.should == 1
    end
  end
end