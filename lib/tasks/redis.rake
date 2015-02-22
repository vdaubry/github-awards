namespace :redis do
  
  desc "Clean sidekiq jobs"
  task clean_sidekiq: :environment do
    require "sidekiq/api"
    Sidekiq::Queue.new.clear
    Sidekiq::RetrySet.new.clear
  end

end