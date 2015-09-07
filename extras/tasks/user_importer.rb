class Tasks::UserImporter
  def crawl_github_users(since)
    client = Models::GithubClient.new(ENV["GITHUB_TOKEN"])
    client.on_found_object = lambda do |user| 
      User.create(github_id: user["id"],
        login: user["login"],
        gravatar_url: user["avatar_url"],
        organization: user["type"]=="Organization")
    end
    
    client.on_too_many_requests = lambda do |error|
      Rails.logger.error error
      sleep 10
      return nil
    end
    
    client.list(:all_users, since)
  end
end