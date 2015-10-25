require "rails_helper"

describe "Oauth::Authorization" do
  
  #credentials=#<OmniAuth::AuthHash expires=false token="fc6c66e14ccfe22e33ae2390d9db791a23b89415">
  let(:credentials) { OmniAuth::AuthHash.new({expires: false, token: "fc6c66e14ccfe22e33ae2390d9db791a23b89415"}) }
  
  #raw_info=#<OmniAuth::AuthHash avatar_url="https://avatars.githubusercontent.com/u/498298?v=3" bio=nil blog="http://www.youboox.fr" company="Youboox" created_at="2010-11-26T20:03:04Z" email="vdaubry@gmail.com" events_url="https://api.github.com/users/vdaubry/events{/privacy}" followers=23 followers_url="https://api.github.com/users/vdaubry/followers" following=6 following_url="https://api.github.com/users/vdaubry/following{/other_user}" gists_url="https://api.github.com/users/vdaubry/gists{/gist_id}" gravatar_id="" hireable=false html_url="https://github.com/vdaubry" id=498298 location="Paris" login="vdaubry" name="vincent daubry" organizations_url="https://api.github.com/users/vdaubry/orgs" public_gists=12 public_repos=40 received_events_url="https://api.github.com/users/vdaubry/received_events" repos_url="https://api.github.com/users/vdaubry/repos" site_admin=false starred_url="https://api.github.com/users/vdaubry/starred{/owner}{/repo}" subscriptions_url="https://api.github.com/users/vdaubry/subscriptions" type="User" updated_at="2015-03-27T11:45:03Z" url="https://api.github.com/users/vdaubry">
  let(:raw_info) { OmniAuth::AuthHash.new({avatar_url:"https://avatars.githubusercontent.com/u/498298?v=3", bio: nil, blog: "http://www.youboox.fr", company: "Youboox", created_at: "2010-11-26T20:03:04Z", email: "vdaubry@gmail.com", followers: 23, following: 6, gravatar_id: "", hireable: false, html_url: "https://github.com/vdaubry", id: 498298, location: "Paris", login: "vdaubry", name: "vincent daubry", public_gists: 12, public_repos: 40, site_admin: false,  type: "User", updated_at: "2015-03-27T11:45:03Z" }) }
  
  #extra=#<OmniAuth::AuthHash raw_info=#<OmniAuth::AuthHash>>
  let(:extra) { OmniAuth::AuthHash.new({raw_info: raw_info}) }
  
  #info=<OmniAuth::AuthHash::InfoHash email="vdaubry@gmail.com" image="https://avatars.githubusercontent.com/u/498298?v=3" name="vincent daubry" nickname="vdaubry" urls=#<OmniAuth::AuthHash Blog="http://www.youboox.fr" GitHub="https://github.com/vdaubry">>
  let(:info) { OmniAuth::AuthHash.new({email: "vdaubry@gmail.com", image: "https://avatars.githubusercontent.com/u/498298?v=3", name: "vincent daubry", nickname: "vdaubry"}) }
  
  #<OmniAuth::AuthHash credentials=#<OmniAuth::AuthHash> extra=#<OmniAuth::AuthHash> info=#<OmniAuth::AuthHash::InfoHash> provider="github" uid="498298">
  let(:auth_hash) { OmniAuth::AuthHash.new({credentials: credentials, extra: extra, info: info, provider: "github", uid: "498298"}) }
  
  
  describe "authorize" do
    context "new user" do
      it "creates user" do
        Oauth::Authorization.new.authorize(auth_hash: auth_hash)
        user = User.where(github_id: '498298').first
        expect(user.email).to eq("vdaubry@gmail.com")
        expect(user.login).to eq("vdaubry")
        expect(user.name).to eq("vincent daubry")
        expect(user.company).to eq("Youboox")
        expect(user.blog).to eq("http://www.youboox.fr")
        expect(user.gravatar_url).to eq("https://avatars.githubusercontent.com/u/498298?v=3")
        expect(user.location).to eq("Paris")
        expect(user.organization).to eq(false)
      end
      
      it "creates authentication provider" do
        Oauth::Authorization.new.authorize(auth_hash: auth_hash)
        authentication_provider = AuthenticationProvider.where(uid: '498298').first
        expect(authentication_provider.user.github_id).to eq(498298)
        expect(authentication_provider.uid).to eq("498298")
        expect(authentication_provider.token).to eq("fc6c66e14ccfe22e33ae2390d9db791a23b89415")
        expect(authentication_provider.provider).to eq("github")
      end
      
      it "returns user" do
        user = Oauth::Authorization.new.authorize(auth_hash: auth_hash)
        expect(user.login).to eq("vdaubry")
      end
    end
    
    context "user already exists" do
      before(:each) do
        @user = FactoryGirl.create(:user, github_id: '498298', location: "foo", email: nil)
      end
      
      it "updates the user" do
        Oauth::Authorization.new.authorize(auth_hash: auth_hash)
        
        users = User.where(github_id: '498298')
        expect(users.count).to eq(1)
        user = users.first
        expect(user.location).to eq("Paris")
        expect(user.email).to eq("vdaubry@gmail.com")
      end
      
      context "not connected to github" do
        it "connects to github" do
          Oauth::Authorization.new.authorize(auth_hash: auth_hash)
          
          user = User.where(github_id: '498298').first
          expect(user.authentication_providers.count).to eq(1)
        end
        
        it "returns user" do
          user = Oauth::Authorization.new.authorize(auth_hash: auth_hash)
          expect(user.login).to eq("vdaubry")
        end
      end
      
      context "already connected to github" do
        before(:each) do
          FactoryGirl.create(:authentication_provider, uid: '498298', token: "foo", user: @user)
        end
        
        it "updates authentication provider" do
          Oauth::Authorization.new.authorize(auth_hash: auth_hash)
          
          authentication_provider = User.where(github_id: '498298').first.authentication_providers.first
          expect(authentication_provider.token).to eq("fc6c66e14ccfe22e33ae2390d9db791a23b89415")
        end
        
        it "returns user" do
          user = Oauth::Authorization.new.authorize(auth_hash: auth_hash)
          expect(user.login).to eq("vdaubry")
        end
      end
      
      context "race condition" do
        it "catches error and updates user" do
          user = FactoryGirl.create(:user, login: "vdaubry")
          User.any_instance.stubs(:save).raises(ActiveRecord::RecordNotUnique.new("")).then.returns(true)
          Oauth::Authorization.new.authorize(auth_hash: auth_hash)
        end
      end
    end
  end
end