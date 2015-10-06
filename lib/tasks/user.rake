namespace :user do
  desc "Crawl github API for users"
  task crawl: :environment do
    Rails.logger.info "Start crawling"
    since = User.last.try(:github_id).try(:to_s) || "0"
    Tasks::UserImporter.new.crawl_github_users(since)
  end
  
  desc "Geocode user locations"
  task :geocode_locations, [:geocoder] => :environment do |t, args|
    geocoder = args.geocoder || :googlemap
    proxy_opts = {http_proxyaddr: "127.0.0.1", http_proxyport: 5566}
    
    User.select("id, location").where("created_at > ?", args.start_date).where("(location IS NOT NULL) AND (location != '') AND ((city IS NULL) OR (city = '')) AND location NOT IN (?)", $redis.smembers("location_error")).each do |user|
      GeocoderWorker.perform_async(user.location, geocoder, proxy_opts)
    end
  end
  
  desc "update a single user data from Github API"
  task :reload, [:login] => :environment do |t, args|
    login = args.login
    Rails.logger.info "Update user #{login}"
    UserUpdateWorker.perform_async(login, true) if login
  end

  desc "Remove user"
  task :remove, [:login] => :environment do |t, args|
    login = args.login
    user = User.where(login: login).first
    Rails.logger.info "Remove user #{user.login}"
    if user
      user.remove_ranks
      user.destroy
    end

    BlacklistedUser.create!(username: login.downcase)
  end
end