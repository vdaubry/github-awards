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
  
  describe "city_rank" do
    it { @presenter.city_rank(@language_rank1).should == "<strong>2</strong> / 5" }
  end
  
  describe "country_rank" do
    it { @presenter.country_rank(@language_rank1).should == "<strong>3</strong> / 6" }
  end
  
  describe "world_rank" do
    it { @presenter.world_rank(@language_rank1).should == "<strong>4</strong> / 7" }
  end
  
  describe "best_rank" do
    it "returns language with best city rank" do
      @presenter.best_rank.should == "<p class=\"\">Tweet your <a href='http://twitter.com/share?text=I am the top 1 css developer in Paris. Check your Github ranking on Github-awards !&url=http://localhost:5000/users/#{URI.encode(@user.login)}' title='Share github-awards on Twitter' target='_blank'>ranking <i class='fa fa-twitter'></i></a></p>"
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