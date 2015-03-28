class UserUpdateWorker
  include Sidekiq::Worker
  sidekiq_options throttle: { threshold: 5000, period: 1.hour }

  def perform(login, include_repo=false)
    github_client = Models::GithubClient.new(ENV['GITHUB_TOKEN2'])
    github_client.on_too_many_requests = lambda do |error|
      raise error
    end
    
    result = github_client.get(:user, login)
    if result.nil?
      Rails.logger.error "User not found : #{login}"
      return 
    end
    
    user = User.where(:login => login).first_or_initialize
    update_user(user, result)
    
    if include_repo
      resp = HTTParty.get("https://api.github.com/users/#{user.login}/repos?access_token=#{ENV['GITHUB_TOKEN2']}").body
      unless resp.nil?
        repos = JSON.parse(resp)
        repos.each do |repo|
          RepositoryUpdateWorker.perform_async(user.id, repo["name"])
        end
      end
    end
    
    if user.location.present?
      Rails.logger.info "geocoding #{user.location}"
      GeocoderWorker.perform_async(user.location, :googlemap, nil) 
    end
    
    RankWorker.perform_async(user.id)
  end
  
  def update_user(user, result)
    user.name = result["name"]
    user.github_id = result["id"]
    user.login = result["login"].downcase if result["login"]
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