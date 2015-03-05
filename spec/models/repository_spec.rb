require 'rails_helper'

describe "Repository" do
  
  describe "new" do
    it { FactoryGirl.build(:repository, :name => nil).save.should == false }
    it { FactoryGirl.build(:repository, :user_id => nil).save.should == false }
    it { FactoryGirl.build(:repository).save.should == true }
  end
  
  describe "unique fields" do
    before(:each) do
      FactoryGirl.create(:repository, :name => "foo", :user_id => "bar")
    end
    
    it "allows different name and user_id" do
      FactoryGirl.build(:repository, :name => "bar", :user_id => "foo").save.should == true
    end
    
    it "forbids duplicates login" do
      FactoryGirl.build(:repository, :name => "foo", :user_id => "bar").save.should == false
    end
  end
  
end