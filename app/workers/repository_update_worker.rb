class RepositoryUpdateWorker
  include Sidekiq::Worker
  sidekiq_options throttle: { threshold: 5000, period: 1.hour }

  def perform(user_id, name)
    Rails.logger.info "Updating repositories for user #{user_id}"
    user = User.find(user_id)
    result = Models::GithubClient.new(ENV['GITHUB_TOKEN']).get(:repo, {:owner => user.login, :repo => name})
    repo = user.repositories.where(:name => name).first_or_initialize
    if result.nil?
      Rails.logger.error "Repo not found : #{repo}"
      return 
    end
    
    update_repo(repo, result) 
    
    RankWorker.perform_async(user_id)
  end
  
  def update_repo(repo, result)
    repo.name = result["name"]
    repo.github_id = result["id"]
    repo.forked = result["fork"] || false
    repo.stars = result["watchers"]
    repo.language = result["language"]
    repo.save
  end
end