require "rails_helper"

describe SessionsController do
render_views

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
  
  
  describe "create" do
    before(:each) do
      stub_request(:get, "https://api.github.com/users/vdaubry").
        to_return(status: 200, body: "", headers: {})
      
      stub_request(:get, "https://api.github.com/users/vdaubry/repos?per_page=100").
        to_return(status: 200, body: "", headers: {})
         
      request.env['omniauth.auth'] = auth_hash
    end
    
    it "finds user from auth_hash" do
      get :create, provider: "github"
      assigns(:user).login.should == "vdaubry"
    end
    
    it "updates user" do
      UserUpdateWorker.expects(:perform_async)
      get :create, provider: "github"
    end
    
    it "redirects to user show" do
      user = FactoryGirl.create(:user, github_id: 498298)
      get :create, provider: "github"
      
      response.should redirect_to user_path("vdaubry")
    end
    
    it "sets user id in session" do
      get :create, provider: "github"
      
      session[:user_id].should_not == nil
    end
    
    context "race condition" do
      it "returns to home page" do
        Oauth::Authorization.any_instance.stubs(:authorize).raises(RaceCondition.new(""))
        get :create, provider: "github"
        response.should redirect_to '/'
      end
    end
  end
  
  describe "failure" do
    it "redirects to home page" do
      get :failure
      response.should redirect_to '/'
    end
  end
end