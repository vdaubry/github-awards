require 'rails_helper'

describe BlacklistedUser do
  describe "validations" do
    it { BlacklistedUser.new(username: "foo").save.should == true }
    it { BlacklistedUser.new(username: nil).save.should == false }

    it "ensure uniqueness of username" do
      BlacklistedUser.new(username: "foo").save.should == true
      BlacklistedUser.new(username: "foo").save.should == false
    end
  end
end