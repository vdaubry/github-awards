class Tasks::RepositoryImporter
  def crawl_github_repos(since)
    client = Models::GithubClient.new(ENV["GITHUB_TOKEN"])
    client.on_found_object = lambda do |repo| 
      Repository.create(:github_id => repo["id"],
        :name => repo["name"], 
        :user => User.where(:login => repo["owner"]["login"]).first,
        :forked => repo["fork"] || false)
    end
    
    client.on_too_many_requests = lambda do |error|
      Rails.logger.error error
      sleep 10
      return nil
    end
    
    client.list(:all_repositories, since)
  end
end