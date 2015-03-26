require 'rails_helper'

describe "UserListPresenter" do
  
  let(:presenter) { UserListPresenter.new(:type => :city) }
  
  describe "new" do
    context "empty location" do
      it "sets default city" do
        UserListPresenter.new(:type => :city).location.should == "san francisco"
      end
      
      it "sets default country" do
        UserListPresenter.new(:type => :country).location.should == "united states"
      end
      
      it "sets default language" do
        presenter.language.should == "JavaScript"
      end
    end

    context "location provided" do
      it "location trim whitespace" do
        UserListPresenter.new(:type => :city, :city => " paris ").location.should == "paris"
      end
    end
  end
  
  describe "languages" do
    it { presenter.languages.count.should == 223 }
  end
  
  describe "title" do
    it { UserListPresenter.new(:type => :city, :city => "paris").title.should == "in Paris" }
    it { UserListPresenter.new(:type => :world).title.should == "worldwide" }
  end
  
  describe "show_location_input" do
    it { UserListPresenter.new(:type => :city).show_location_input?.should == true }
    it { UserListPresenter.new(:type => :world).show_location_input?.should == false }
  end
  
  describe "user_ranks" do
    context "has results" do
      it "returns top users for this city and language ordered by city rank" do
        u1 = FactoryGirl.create(:user)
        u2 = FactoryGirl.create(:user)
        u3 = FactoryGirl.create(:user)
        r1 = FactoryGirl.create(:repository, :user => u1, :language => "ruby")
        r2 = FactoryGirl.create(:repository, :user => u2, :language => "ruby")
        r3 = FactoryGirl.create(:repository, :user => u3, :language => "ruby")
        
        $redis.zadd("user_ruby_paris", 1.1, u1.id)
        $redis.zadd("user_ruby_paris", 3.2, u2.id)
        $redis.zadd("user_ruby_paris", 2.2, u3.id)
        
        presenter = UserListPresenter.new(:type => :city, :city => "paris", :language => "ruby") 
        
        presenter.user_ranks[0].user.id.should == u2.id
        presenter.user_ranks[1].user.id.should == u3.id
        presenter.user_ranks[2].user.id.should == u1.id
      end
    end
    
    context "has no result" do
      it "returns empty" do
        presenter = UserListPresenter.new(:type => :city, :city => "paris", :language => "ruby") 
        presenter.user_ranks.should == []
      end
    end
  end
end