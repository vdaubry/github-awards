require 'rails_helper'

describe "Repository" do
  
  describe "new" do
    it { expect(FactoryGirl.build(:repository, name: nil).save).to eq(false) }
    it { expect(FactoryGirl.build(:repository, user_id: nil).save).to eq(false) }
    it { expect(FactoryGirl.build(:repository).save).to eq(true) }
  end
  
  describe "unique fields" do
    before(:each) do
      FactoryGirl.create(:repository, name: "foo", user_id: "bar")
    end
    
    it "allows different name and user_id" do
      expect(FactoryGirl.build(:repository, name: "bar", user_id: "foo").save).to eq(true)
    end
    
    it "forbids duplicates login" do
      expect(FactoryGirl.build(:repository, name: "foo", user_id: "bar").save).to eq(false)
    end
  end
  
end