require "rails_helper"

VCR.configure do |c|
  c.cassette_library_dir = 'spec/fixtures/cassette_library'
  c.hook_into :webmock
  c.default_cassette_options = { record: :new_episodes }
  c.configure_rspec_metadata!
end

describe RepositoryStreamWorker, vcr: true do
  
  before(:each) do
    repos_json = File.read("spec/fixtures/githubArchive/repos.json")
    io = StringIO.new("w")
    gz = Zlib::GzipWriter.new(io)
    gz.write(repos_json)
    gz.close
     
    stub_request(:get, "http://data.githubarchive.org/2015-04-04-16.json.gz").
       with(headers: {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'User-Agent'=>'Ruby'}).
       to_return(status: 200, body: io.string, headers: {})
  end
  
  context "user doesn't exist" do
    it "creates users and repos" do
      RepositoryStreamWorker.new.perform(time: DateTime.parse("2015-04-04 16:00"))
      expect(User.count).to eq(2)
      expect(Repository.count).to eq(35)
      expect(User.where(login: "ahmed-talaat").first.country).to eq("egypt")
    end
  end
  
  context "user exist" do
    before(:each) do
      @user = FactoryGirl.create(:user, login: "ahmed-talaat", country: nil)
    end
    
    it "doesn't update user" do
      RepositoryStreamWorker.new.perform(time: DateTime.parse("2015-04-04 16:00"))
      expect(User.where(login: @user.login).first.country).to eq(nil)
    end
    
    it "updates repo" do
      FactoryGirl.create(:repository, user: @user, name: "Android-Arabic-Fonts", stars: 0)
      RepositoryStreamWorker.new.perform(time: DateTime.parse("2015-04-04 16:00"))
      expect(@user.repositories.where(name: "Android-Arabic-Fonts").first.stars).to eq(1)
    end
  end
end