require "rails_helper"

describe "AuthenticationProvider" do
  describe "create" do
    context "valid" do
      it {  expect(FactoryGirl.build(:authentication_provider).save).to eq(true) }
      
      it "attaches authentication provider to user" do
        user = FactoryGirl.create(:user)
        auth_provider = FactoryGirl.build(:authentication_provider)
        user.authentication_providers << auth_provider
        user.save
        expect(user.reload.authentication_providers.count).to eq(1)
      end
    end
    
    context "duplicate authentication provider" do
      it "doesn't save duplicate uid" do
        expect(FactoryGirl.build(:authentication_provider, uid: "foo").save).to eq(true)
        expect(FactoryGirl.build(:authentication_provider, uid: "foo").save).to eq(false)
      end
      
      it "attaches only one authentication provider to user" do
        user = FactoryGirl.create(:user)
        auth_provider = FactoryGirl.build(:authentication_provider)
        user.authentication_providers << auth_provider
        user.authentication_providers << auth_provider
        user.save
        expect(user.reload.authentication_providers.count).to eq(1)
      end
    end
    
    context "missing attributes" do
      it { expect(FactoryGirl.build(:authentication_provider, user: nil).save).to eq(false) }
      it { expect(FactoryGirl.build(:authentication_provider, uid: nil).save).to eq(false) }
      it { expect(FactoryGirl.build(:authentication_provider, token: nil).save).to eq(false) }
      it { expect(FactoryGirl.build(:authentication_provider, provider: nil).save).to eq(false) }
    end
  end
end