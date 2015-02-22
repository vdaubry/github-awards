class UserUpdateWorker
  include Sidekiq::Worker
  #sidekiq_options throttle: { threshold: 5000, period: 1.hour }

  def perform(login, include_repo=false)
    result = Models::GithubClient.new(ENV['GITHUB_TOKEN2']).get(:user, login)
    user = User.where(:login => login).first_or_initialize
    if result.nil?
      Rails.logger.error "User not found : #{login}"
      return 
    end
    
    update_user(user, result)
    
    if include_repo
      repos = JSON.parse(HTTParty.get("https://api.github.com/users/camilleroux/repos?access_token=#{ENV['GITHUB_TOKEN2']}").body)
      repos.each do |repo|
        RepositoryUpdateWorker.perform_async(user.login, repo["name"])
      end
    end
  end
  
  def update_user(user, result)
    user.name = result["name"]
    user.github_id = result["id"]
    user.login = result["login"]
    user.company = result["company"]
    user.location = result["location"]
    user.blog = result["blog"]
    user.email = result["email"]
    user.gravatar_url = result["avatar_url"]
    user.organization = result["type"]=="Organization"
    user.processed = true
    user.save
  end
end