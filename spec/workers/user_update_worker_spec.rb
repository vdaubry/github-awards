require 'rails_helper'

describe UserUpdateWorker do
  
  let(:github_result) { JSON.parse(File.read("spec/fixtures/github/user.json")) }
  
  describe "perform" do
    context "new user" do
      before(:each) do
        stub_request(:get, "https://maps.googleapis.com/maps/api/geocode/json?address=Paris").
            with(headers: {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'User-Agent'=>'Ruby'}).
            to_return(status: 200, body: "", headers: {})

        Models::GithubClient.any_instance.stubs(:get).returns(github_result)
      end

      it "creates user" do
        UserUpdateWorker.perform_async("vdaubry")
        expect(User.count).to eq(1)
      end

      context "blacklisted user" do
        it "ignores user" do
          BlacklistedUser.create(username: "vdaubry")
          UserUpdateWorker.perform_async("vdaubry")
          expect(User.count).to eq(0)
        end
      end
    end
    
    context "user not found on github" do
      it "ignores user" do
        Models::GithubClient.any_instance.stubs(:get).returns(nil)
        UserUpdateWorker.perform_async("vdaubry")
        expect(User.count).to eq(0)
      end
    end
  end
  
  describe "update_user" do
    it "updates user" do
      user = FactoryGirl.create(:user)
      UserUpdateWorker.new.update_user(user, github_result)
      user.reload
      expect(user.login).to eq("vdaubry")
      expect(user.blog).to eq("http://www.youboox.fr")
      expect(user.company).to eq("Youboox")
      expect(user.name).to eq("vincent daubry")
      expect(user.email).to eq("vdaubry@gmail.com")
      expect(user.location).to eq("Paris")
      expect(user.organization).to eq(true)
      expect(user.gravatar_url).to eq("https://avatars.githubusercontent.com/u/498298?v=3")
    end
  end
end