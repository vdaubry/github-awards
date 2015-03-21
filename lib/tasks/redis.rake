namespace :redis do
  
  desc "Clean sidekiq jobs"
  task clear_sidekiq: :environment do
    require "sidekiq/api"
    Sidekiq::Queue.new.clear
    Sidekiq::RetrySet.new.clear
  end
  
  desc "Load ranking in redis"
  task set_ranks: :environment do
    User.select("users.id").joins(:repositories).where("repositories.language IS NOT NULL").distinct.find_each(:batch_size => 2000) do |user|
      puts "setting rank for user #{user.id}"
      RankWorker.perform_async(user.id)
    end
  end

end