require 'rails_helper'

describe Models::GithubClient do
  
  let(:valid_response) { JSON.parse(File.read("spec/fixtures/github/user.json")) }
  
  describe "get" do
    it "returns github api response" do
      Octokit::Client.any_instance.stubs(:user).with("vdaubry").returns(valid_response)
      result = Models::GithubClient.new.get(:user, "vdaubry")
      expect(result["login"]).to eq("vdaubry")
    end
  end
end