require "rails_helper"

describe "AuthenticationProvider" do
  describe "create" do
    context "valid" do
      it {  FactoryGirl.build(:authentication_provider).save.should == true }
      
      it "attaches authentication provider to user" do
        user = FactoryGirl.create(:user)
        auth_provider = FactoryGirl.build(:authentication_provider)
        user.authentication_providers << auth_provider
        user.save
        user.reload.authentication_providers.count.should == 1
      end
    end
    
    context "duplicate authentication provider" do
      it "doesn't save duplicate uid" do
        FactoryGirl.build(:authentication_provider, uid: "foo").save.should == true
        FactoryGirl.build(:authentication_provider, uid: "foo").save.should == false
      end
      
      it "attaches only one authentication provider to user" do
        user = FactoryGirl.create(:user)
        auth_provider = FactoryGirl.build(:authentication_provider)
        user.authentication_providers << auth_provider
        user.authentication_providers << auth_provider
        user.save
        user.reload.authentication_providers.count.should == 1
      end
    end
    
    context "missing attributes" do
      it { FactoryGirl.build(:authentication_provider, user: nil).save.should == false }
      it { FactoryGirl.build(:authentication_provider, uid: nil).save.should == false }
      it { FactoryGirl.build(:authentication_provider, token: nil).save.should == false }
      it { FactoryGirl.build(:authentication_provider, provider: nil).save.should == false }
    end
  end
end