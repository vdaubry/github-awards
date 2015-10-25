require 'rails_helper'

describe Tasks::UserImporter do
  describe "crawl_github_users" do
    it "iterates while max users is reached" do
      Octokit::Client.any_instance.stubs(:all_users)
      .returns([{"login" => "foo1", id: 0}, {"login" => "foo2", id: 1}])
      .then.returns([{"login" => "foo3", id: 2}])
      Models::GithubClient.any_instance.stubs(:max_list_size).returns(2)
      Tasks::UserImporter.new.crawl_github_users("0")
      expect(User.count).to eq(3)
    end
    
    context "network error" do
      it "continues crawling" do
        Octokit::Client.any_instance.stubs(:all_users).raises(Errno::ETIMEDOUT)
        .then.returns([{"login" => "foo", "id" => 0}])
        Tasks::UserImporter.new.crawl_github_users("0")
        expect(User.count).to eq(1)
      end
    end
  end
end