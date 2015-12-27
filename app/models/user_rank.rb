class UserRank
  attr_accessor :user, :language, :stars_count, :repository_count

  def initialize(user, language, stars_count, repository_count)
    @user = user
    @language = language
    @stars_count = stars_count
    @repository_count = repository_count
  end

  def city_rank
    rank("user_#{language}_#{user.city}")
  end

  def country_rank
    rank("user_#{language}_#{user.country}")
  end

  def world_rank
    rank("user_#{language}")
  end

  def city_user_count
    count("user_#{language}_#{user.city}")
  end

  def country_user_count
    count("user_#{language}_#{user.country}")
  end

  def world_user_count
    count("user_#{language}")
  end

  def remove
    remove_key("user_#{language}_#{user.city}") if user.city
    remove_key("user_#{language}_#{user.country}") if user.country
    remove_key("user_#{language}")
  end

  private
  def remove_key(key)
    $redis.zrem(key.redis_key, user.id)
  end


  def rank(key)
    key = key.redis_key
    result = $redis.zrevrank(key, user.id)

    #if an error occured when updating user location we force a new ranking compute with the new location
    if result.nil?
      RankWorker.new.perform(user.id)
      result = $redis.zrevrank(key, user.id)
    end

    result.try(:+, 1)
  end

  def count(key)
    $redis.zcard(key.redis_key)
  end
end
