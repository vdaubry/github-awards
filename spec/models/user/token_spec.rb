require "rails_helper"

describe User::Token do
  describe "token" do
    context "not connected to github" do
      it { expect(FactoryGirl.build(:user).token).to be_nil }
    end

    context "connected to github" do
      it "returns oauth token" do
        user = FactoryGirl.create(:user)
        FactoryGirl.create(:authentication_provider, user: user, token: "foobar")
        expect(user.token).to eq("foobar")
      end
    end
  end
end