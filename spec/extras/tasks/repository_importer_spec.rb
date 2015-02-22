require 'rails_helper'

describe Tasks::UserImporter do
  describe "crawl_github_repos" do
    it "creates the repo" do
      stub_response = JSON.parse(File.read("spec/fixtures/github/repos.json"))
      Octokit::Client.any_instance.stubs(:all_repositories).returns(stub_response)
      Tasks::RepositoryImporter.new.crawl_github_repos("0")
      repo = Repository.first
      repo.github_id.should == 17654
      repo.name.should == "grit"
      repo.user_id.should == "mojombo"
      repo.forked.should == true
    end
    
    it "iterates while max repos is reached" do
      Octokit::Client.any_instance.stubs(:all_repositories)
      .returns([{"owner" => {"login" => "foo1"}, "name" => "bar1", "id" => 0}, {"owner" => {"login" => "foo2"}, "name" => "bar2", "id" => 1}])
      .then.returns([{"owner" => {"login" => "foo3"}, "name" => "bar3", "id" => 2}])
      Models::GithubClient.any_instance.stubs(:max_list_size).returns(2)
      Tasks::RepositoryImporter.new.crawl_github_repos("0")
      Repository.count.should == 3
    end
    
    context "network error" do
      it "continues crawling" do
        Octokit::Client.any_instance.stubs(:all_repositories).raises(Errno::ETIMEDOUT)
        .then.returns([{"owner" => {"login" => "foo3"}, "name" => "bar3", :id => 2}])
        Tasks::RepositoryImporter.new.crawl_github_repos("0")
        Repository.count.should == 1
      end
    end
  end
end

