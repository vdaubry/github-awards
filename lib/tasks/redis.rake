namespace :redis do
  
  desc "Clean sidekiq jobs"
  task clean_sidekiq: :environment do
    require "sidekiq/api"
    Sidekiq::Queue.new.clear
    Sidekiq::RetrySet.new.clear
  end
  
  desc "Load ranking in redis"
  task set_ranks: :environment do
    # #load ranking by city
    # cities = LanguageRank.select(:city).where("city IS NOT NULL").distinct.map(&:city)
    # cities.each do |city|
    #   puts "setting ranks for #{city}"
    #   RankWorker.perform_async(:city, city)
    # end
    
    # #load ranking by country
    # countries = LanguageRank.select(:country).where("country IS NOT NULL").distinct.map(&:country)
    # countries.each do |country|
    #   puts "setting ranks for #{country}"
    #   RankWorker.perform_async(:country, country)
    # end
    
    #load ranking worldwide
    languages = LanguageRank.select(:language).distinct.map(&:language)
    languages.each do |language|
      puts "setting ranks for #{language}"
      RankWorker.perform_async(:language, language)
    end
  end

end