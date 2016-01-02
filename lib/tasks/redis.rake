namespace :redis do
  
  desc "Clean sidekiq jobs"
  task clear_sidekiq: :environment do
    require "sidekiq/api"
    Sidekiq::Queue.new.clear
    Sidekiq::RetrySet.new.clear
  end
  
  desc "Load ranking in redis"
  task set_ranks: :environment do
    User.select("users.id").joins(:repositories).where("users.organization=false AND repositories.language IS NOT NULL").distinct.find_each(:batch_size => 2000) do |user|
      puts "setting rank for user #{user.id}"
      RankWorker.perform_async(user.id)
    end
  end

  desc "rename keys"
  task rename_keys: :environment do
    puts "rename redis keys "
    $redis.keys.each do |key|
      $redis.rename(key, key.redis_key) if key != key.redis_key
    end
  end

  desc "rename language keys"
  task rename_languages: :environment do
    puts "rename languages"
    ActiveRecord::Base.connection.execute("update repositories set language=lower(replace(language, ' ', '_'))")
  end

end