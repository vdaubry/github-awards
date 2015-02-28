require 'rails_helper'

describe "UserListPresenter" do
  before(:each) do 
    @user = FactoryGirl.create(:user)
    @language_rank1 = FactoryGirl.create(:language_rank, 
      :user => @user,
      :language => "ruby", 
      :city_rank => 2, 
      :country_rank => 3, 
      :world_rank => 4,
      :city_user_count => 5,
      :country_user_count => 6,
      :world_user_count => 7)
    @language_rank2 = FactoryGirl.create(:language_rank, 
      :user => @user,
      :language => "css", 
      :city_rank => 1, 
      :country_rank => 1, 
      :world_rank => 3,
      :city => "Paris",
      :country => "France")
    @presenter = LanguageRankPresenter.new([@language_rank1, @language_rank2])
  end
  
  describe "city_infos" do
    context "city present" do
      it "returns city ranking" do
        @presenter.city_infos(@language_rank2).should == "<td class=\"col-md-3\"><a href=\"/users?city=string&amp;language=css&amp;type=city\">String</a></td><td><strong>1</strong> / 4 <i class='fa fa-trophy'></i></td>"
      end
    end
    context "city missing" do
      it "returns missing city message" do
        @presenter.city_infos(@language_rank1).should == "<td colspan=\"2\"><p>We couldn't find your city from your location on GitHub :( </p><p>You can manually search for <a href=\"/users?language=ruby\">top Ruby GitHub developers in your city</a></p></td>"
      end
    end
  end
  
  describe "country_infos" do
    context "country present" do
      it "returns country ranking" do
        @presenter.country_infos(@language_rank2).should == "<td class=\"col-md-3\"><a href=\"/users?country=string&amp;language=css&amp;type=country\">String</a></td><td><strong>1</strong> / 5 <i class='fa fa-trophy'></i></td>"
      end
    end
    context "country missing" do
      it "returns nil" do
        @presenter.country_infos(@language_rank1).should == nil
      end
    end
  end
  
  describe "world_infos" do
    it { @presenter.world_infos(@language_rank1).should == "<td class=\"col-md-3\"><a href=\"/users?language=ruby&amp;type=world\">Worldwide</a></td><td><strong>4</strong> / 7 <i class='fa fa-trophy'></i></td>" }
  end
  
  describe "best_rank" do
    it "returns language with best city rank" do
      @presenter.best_rank.should == "<p>Tweet your <a href='http://twitter.com/share?text=I am the top 1 css developer in Paris. Check your GitHub ranking on GitHub Awards !&url=http://localhost:5000/users/#{URI.encode(@user.login)}' title='Share GitHub Awards on Twitter' target='_blank'>ranking <i class='fa fa-twitter'></i></a></p>"
    end
    
    context "no ranking" do
      it "returns nil" do
         LanguageRankPresenter.new([]).best_rank.should == nil
      end
    end
    
    context "no city" do
      it "returns nil" do
        language_rank = FactoryGirl.create(:language_rank, :city => nil)
        LanguageRankPresenter.new([language_rank]).best_rank.should == nil
      end
    end
  end
end