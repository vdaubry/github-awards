require 'rails_helper'

describe UserUpdateWorker do
  
  let(:github_result) { JSON.parse(File.read("spec/fixtures/github/user.json")) }
  
  describe "perform" do
    context "new user" do   
      it "creates user" do
        stub_request(:get, "https://maps.googleapis.com/maps/api/geocode/json?address=Paris").
         with(:headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'User-Agent'=>'Ruby'}).
         to_return(:status => 200, :body => "", :headers => {})
      
        Models::GithubClient.any_instance.stubs(:get).returns(github_result)
        UserUpdateWorker.perform_async("user")
        User.count.should == 1
      end
    end
    
    context "user not found on github" do
      it "ignores user" do
        Models::GithubClient.any_instance.stubs(:get).returns(nil)
        UserUpdateWorker.perform_async("user")
        User.count.should == 0
      end
    end
  end
  
  describe "update_user" do
    it "updates user" do
      user = FactoryGirl.create(:user)
      UserUpdateWorker.new.update_user(user, github_result)
      user.reload
      user.login.should == "vdaubry"
      user.blog.should == "http://www.youboox.fr"
      user.company.should == "Youboox"
      user.name.should == "vincent daubry"
      user.email.should == "vdaubry@gmail.com"
      user.location.should == "Paris"
      user.organization.should == true
      user.gravatar_url.should == "https://avatars.githubusercontent.com/u/498298?v=3"
    end
  end
end