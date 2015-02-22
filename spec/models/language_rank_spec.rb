require 'rails_helper'

describe "LanguageRank" do
  
  describe "new" do
    it { FactoryGirl.build(:language_rank).save.should == true }
  end
  
  describe "unique fields" do
    it "allows different languages" do
      FactoryGirl.build(:language_rank, :user_id => 123, :language => "ruby", :city => "paris", :country => "france").save.should == true
    end
    
    it "forbids duplicates languages for city" do
      FactoryGirl.create(:language_rank, :user_id => 123, :language => "ruby", :city => "paris", :country => nil)
      FactoryGirl.build(:language_rank, :user_id => 123, :language => "ruby", :city => "paris", :country => nil).save.should == false
    end
    
    it "forbids duplicates languages for country" do
      FactoryGirl.create(:language_rank, :user_id => 123, :language => "ruby", :city => nil, :country => "france")
      FactoryGirl.build(:language_rank, :user_id => 123, :language => "ruby", :city => nil, :country => "france").save.should == false
    end
    
    it "forbids duplicates languages" do
      FactoryGirl.create(:language_rank, :user_id => 123, :language => "ruby", :city => nil, :country => nil)
      FactoryGirl.build(:language_rank, :user_id => 123, :language => "ruby", :city => nil, :country => nil).save.should == false
    end
  end
end