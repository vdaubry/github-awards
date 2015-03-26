require 'rails_helper'

describe RepositoryUpdateWorker do
  
  let(:github_result) { JSON.parse(File.read("spec/fixtures/github/repo.json")) }
  let(:user) { FactoryGirl.create(:user) }
  
  describe "perform" do
    context "new repo" do
      it "creates repo" do
        Models::GithubClient.any_instance.stubs(:get).returns(github_result)
        RepositoryUpdateWorker.perform_async(user.id, "foo")
        user.repositories.count.should == 1
      end
    end
    
    context "repo not found on github" do
      it "ignores repo" do
        Models::GithubClient.any_instance.stubs(:get).returns(nil)
        RepositoryUpdateWorker.perform_async(user.id, "foo")
        user.repositories.count.should == 0
      end
    end
  end
  
  describe "update_repo" do
    it "updates repo" do
      repo = FactoryGirl.create(:repository)
      RepositoryUpdateWorker.new.update_repo(repo, github_result)
      repo.reload
      repo.name.should == "github-awards"
      repo.github_id.should == 29809978
      repo.forked.should == true
      repo.stars.should == 2
      repo.language.should == "Ruby"
    end
  end
end