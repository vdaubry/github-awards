require "rails_helper"

describe RankWorker do
  
  describe "perform" do

    before(:each) do
      FactoryGirl.create(:repository, :user => user, :language => "ruby", :stars => 2)
      FactoryGirl.create(:repository, :user => user, :language => "ruby", :stars => 0)
      FactoryGirl.create(:repository, :user => user, :language => "javascript", :stars => 0)
      FactoryGirl.create(:repository, :user => user, :language => nil, :stars => 0)
    end

    context "user has city and country" do
      let(:user) { FactoryGirl.create(:user, :city => "paris", :country => "france") }
  
      it "sets city rank" do
        RankWorker.new.perform(user.id)
        $redis.zscore("user_ruby_paris", user.id).should == 2.5
      end
      
      it "sets country rank" do
        RankWorker.new.perform(user.id)
        $redis.zscore("user_ruby_france", user.id).should == 2.5
      end
      
      it "sets world rank" do
        RankWorker.new.perform(user.id)
        $redis.zscore("user_ruby", user.id).should == 2.5
      end
    end
    
    context "user has country but no city" do
      let(:user) { FactoryGirl.create(:user, :city => nil, :country => "france") }
  
      it "doesn't set city rank" do
        RankWorker.new.perform(user.id)
        $redis.zscore("user_ruby_paris", user.id).should == nil
      end
    end
    
    context "user has no country and no city" do
      let(:user) { FactoryGirl.create(:user, :city => nil, :country => nil) }
  
      it "doesn't set country rank" do
        RankWorker.new.perform(user.id)
        $redis.zscore("user_ruby_france", user.id).should == nil
      end
    end
  end
end