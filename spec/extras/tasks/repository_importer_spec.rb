require 'rails_helper'

describe Tasks::UserImporter do
  describe "crawl_github_repos" do
    it "creates the repo" do
      stub_response = JSON.parse(File.read("spec/fixtures/github/repos.json"))
      Octokit::Client.any_instance.stubs(:all_repositories).returns(stub_response)
      user = FactoryGirl.create(:user, login: "mojombo")
      
      Tasks::RepositoryImporter.new.crawl_github_repos("0")
      
      repo = Repository.first
      expect(repo.github_id).to eq(17654)
      expect(repo.name).to eq("grit")
      expect(repo.user).to eq(user)
      expect(repo.forked).to eq(true)
    end
    
    it "iterates while max repos is reached" do
      FactoryGirl.create(:user, login: "foo1")
      Octokit::Client.any_instance.stubs(:all_repositories)
      .returns([{"owner" => {"login" => "foo1"}, "name" => "bar1", "id" => 0}, {"owner" => {"login" => "foo1"}, "name" => "bar2", "id" => 1}])
      .then.returns([{"owner" => {"login" => "foo1"}, "name" => "bar3", "id" => 2}])
      Models::GithubClient.any_instance.stubs(:max_list_size).returns(2)
      Tasks::RepositoryImporter.new.crawl_github_repos("0")
      expect(Repository.count).to eq(3)
    end
    
    context "network error" do
      it "continues crawling" do
        FactoryGirl.create(:user, login: "foo1")
        Octokit::Client.any_instance.stubs(:all_repositories).raises(Errno::ETIMEDOUT)
        .then.returns([{"owner" => {"login" => "foo1"}, "name" => "bar3", id: 2}])
        Tasks::RepositoryImporter.new.crawl_github_repos("0")
        expect(Repository.count).to eq(1)
      end
    end
  end
end

