require "rails_helper"

describe Models::Stream do
  
  let(:stream) { Models::Stream.new(time: DateTime.parse("2015-04-04 16:00")) }
  
  before(:each) do
    repos_json = File.read("spec/fixtures/githubArchive/repos.json")
    @io = StringIO.new("w")
    gz = Zlib::GzipWriter.new(@io)
    gz.write(repos_json)
    gz.close
    
    stub_request(:get, "http://data.githubarchive.org/2015-04-04-16.json.gz").
       with(:headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'User-Agent'=>'Ruby'}).
       to_return(:status => 200, :body => @io.string, :headers => {})
  end
  
  describe "parse" do
    it "adds unique watched repos in redis" do
      stream.parse
      $redis.smembers("stream_repos").size.should == 2
    end
    
    it "downloads filename with hour zero blanked" do
      stream = Models::Stream.new(time: DateTime.parse("2015-04-04 09:00"))
      
      #Check that we download a file called 2015-04-04-9.json.gz
      stub_request(:get, "http://data.githubarchive.org/2015-04-04-9.json.gz").
       with(:headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'User-Agent'=>'Ruby'}).
       to_return(:status => 200, :body => @io.string, :headers => {})
      stream.parse
    end
  end
  
  describe "each" do
    it "iterates on all values" do
      res = []
      stream.parse
      stream.each do |repo_name|
        res << repo_name
      end
      
      res.should =~ ["Ahmed-Talaat/Android-Arabic-Fonts", "phonegap-build/PushPlugin"]
    end
  end
end