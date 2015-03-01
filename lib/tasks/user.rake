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
  
  desc "Parse events from GithubArchive and update corresponding users"
  task parse_users: :environment do
    filepath = "ressources/users000000000000.json"
    UserStreamWorker.perform_async(filepath)
  end
  
  desc "update a single user data from Github API"
  task :reload, [:login] => :environment do |t, args|
    login = args.login
    Rails.logger.info "Update user #{login}"
    if login
      UserUpdateWorker.perform_async(login, true)
    end
  end
  
  desc "update all not processed users"
  task process: :environment do
    LanguageRank.select("user_id, sum(stars_count) as total_stars").joins(:user).where(:users => {:processed => false}).group("user_id").order("total_stars desc").limit(1000).each do |languageRank|
      login = languageRank.user.login
      Rails.logger.info "Processing user #{login}"
      UserUpdateWorker.perform_async(login)
    end
  end
  
  desc "remove user"
  task :delete, [:login] => :environment do |t, args|
    login = args.login
    user = User.where(:login => login).first
    Repository.where(:user_id => login).destroy_all
    LanguageRank.where(:user_id => user.id).delete_all
    user.destroy
  end
end