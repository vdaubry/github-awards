class RankWorker
  include Sidekiq::Worker
  
  def perform(user_id)
    user = User.find(user_id)
    
    user.repositories.with_language.select("language, count(repositories.id) as repository_count, sum(stars) as stars_count").group("repositories.language").each do |repo|
      score = repo.stars_count + (1.0 - 1.0/repo.repository_count)
      $redis.zadd("user_#{repo.language}_#{user.city}", score, user.id) if user.city
      $redis.zadd("user_#{repo.language}_#{user.country}", score, user.id) if user.country
      $redis.zadd("user_#{repo.language}", score, user.id)
    end
  end
end