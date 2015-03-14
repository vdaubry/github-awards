class RankWorker
  include Sidekiq::Worker
  
  def perform(user_id)
    user = User.find(user_id)
    
    Repository.where("language IS NOT NULL AND user_id=#{user_id}").select("language, count(repositories.id) as repository_count, sum(stars) as stars_count").group("repositories.language").each do |repos|
      score = repos.stars_count + (1.0 - 1.0/repos.repository_count)
      $redis.zadd("user_#{repos.language}_#{user.city}", score, user.id) if user.city
      $redis.zadd("user_#{repos.language}_#{user.country}", score, user.id) if user.country
      $redis.zadd("user_#{repos.language}", score, user.id)
    end
  end
end