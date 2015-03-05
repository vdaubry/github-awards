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
        presenter.language.should == "javascript"
      end
    end

    context "location provided" do
      it "location trim whitespace" do
        UserListPresenter.new(:type => :city, :city => " paris ").location.should == "paris"
      end
    end
  end
  
  describe "languages" do
    it { presenter.languages.count.should == 219 }
  end
  
  describe "title" do
    it { UserListPresenter.new(:type => :city, :city => "paris").title.should == "in Paris" }
    it { UserListPresenter.new(:type => :world).title.should == "worldwide" }
  end
  
  describe "show_location_input" do
    it { UserListPresenter.new(:type => :city).show_location_input.should == true }
    it { UserListPresenter.new(:type => :world).show_location_input.should == false }
  end
  
  describe "language_ranks" do
    context "has results" do
      it "returns top users for this city and language ordered by city rank" do
        lr1 = FactoryGirl.create(:language_rank, :city => "paris", :language => "ruby", :city_rank => 1)
        lr3 = FactoryGirl.create(:language_rank, :city => "paris", :language => "ruby", :city_rank => 3)
        lr2 = FactoryGirl.create(:language_rank, :city => "paris", :language => "ruby", :city_rank => 2)
        
        presenter = UserListPresenter.new(:type => :city, :city => "paris", :language => "ruby") 
        presenter.language_ranks.should == [lr1, lr2, lr3]
      end
    end
    
    context "has no result" do
      it "returns empty" do
        presenter = UserListPresenter.new(:type => :city, :city => "paris", :language => "ruby") 
        presenter.language_ranks.should == []
      end
    end
  end
end