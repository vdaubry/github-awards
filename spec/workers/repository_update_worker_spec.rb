require 'rails_helper'

describe RepositoryUpdateWorker do
  
  let(:github_result) { JSON.parse(File.read("spec/fixtures/github/repo.json")) }
  let(:user) { FactoryGirl.create(:user) }
  
  describe "perform" do
    context "new repo" do
      it "creates repo" do
        Models::GithubClient.any_instance.stubs(:get).returns(github_result)
        RepositoryUpdateWorker.perform_async(user.id, "foo")
        expect(user.repositories.count).to eq(1)
      end
    end
    
    context "repo not found on github" do
      it "ignores repo" do
        Models::GithubClient.any_instance.stubs(:get).returns(nil)
        RepositoryUpdateWorker.perform_async(user.id, "foo")
        expect(user.repositories.count).to eq(0)
      end
    end
  end
  
  describe "update_repo" do
    it "updates repo" do
      repo = FactoryGirl.create(:repository)
      RepositoryUpdateWorker.new.update_repo(repo, github_result)
      repo.reload
      expect(repo.name).to eq("github-awards")
      expect(repo.github_id).to eq(29809978)
      expect(repo.forked).to eq(true)
      expect(repo.stars).to eq(2)
      expect(repo.language).to eq("Ruby")
    end
    
    it "updates user rank" do
      Models::GithubClient.any_instance.stubs(:get).returns({})
      RepositoryUpdateWorker.any_instance.stubs(:update_repo).returns(:nil)
      
      user = FactoryGirl.create(:user, city: "paris")
      repo = FactoryGirl.create(:repository, language: "ruby", name: "flowl", stars: 5, user: user)
      $redis.zadd("user_ruby_paris", 1.0, user.id)
      
      RepositoryUpdateWorker.new.perform(user.id, "foobar")
      
      expect($redis.zscore("user_ruby_paris", user.id)).to eq(5.0)
    end
  end
end