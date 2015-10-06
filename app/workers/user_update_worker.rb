class UserUpdateWorker
  include Sidekiq::Worker
  sidekiq_options throttle: { threshold: 5000, period: 1.hour }

  def perform(login, include_repo=false)
    return if BlacklistedUser.where(username:login.downcase).count > 0

    github_client = Models::GithubClient.new(ENV['GITHUB_TOKEN'])
    github_client.on_too_many_requests = lambda do |error|
      raise error
    end
    
    result = github_client.get(:user, login)
    if result.nil?
      Rails.logger.error "User not found : #{login}"
      return 
    end
    
    user = User.where(login: login.downcase).first_or_initialize
    update_user(user, result)
    
    if include_repo
      url = "https://api.github.com/users/#{user.login}/repos?per_page=100"
      url += "&access_token=#{ENV['GITHUB_TOKEN']}" if ENV['GITHUB_TOKEN']
      resp = HTTParty.get(url).body
      
      unless resp.nil?
        repos = JSON.parse(resp)
        repos.each do |repo|
          #perform synchronously to be sure all repos are updating when we compute rank
          RepositoryUpdateWorker.new.perform(user.id, repo["name"])
        end
      end
    end
    
    if user.location.present?
      #perform synchronously to be sure all repos are updating when we compute rank
      GeocoderWorker.new.perform(user.location, :googlemap, nil) 
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