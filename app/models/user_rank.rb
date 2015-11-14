class UserRank
  attr_accessor :user, :language, :stars_count, :repository_count
  
  def initialize(user, language, stars_count, repository_count)
    @user = user
    @language = language
    @stars_count = stars_count
    @repository_count = repository_count
  end
  
  def city_rank
    rank("user_#{@language}_#{@user.city}")
  end
  
  def country_rank
    rank("user_#{@language}_#{@user.country}")
  end
  
  def world_rank
    rank("user_#{@language}")
  end
  
  def city_user_count
    count("user_#{@language}_#{@user.city}")
  end
  
  def country_user_count
    count("user_#{@language}_#{@user.country}")
  end
  
  def world_user_count
    count("user_#{@language}")
  end

  def remove
    $redis.zrem("user_#{@language}_#{@user.city}", user.id) if user.city
    $redis.zrem("user_#{@language}_#{@user.country}", user.id) if user.country
    $redis.zrem("user_#{@language}", user.id)
  end
  
  private
  def rank(key)
    result = $redis.zrevrank(key, @user.id)
    
    #if an error occured when updating user location we force a new ranking compute with the new location
    if result.nil?
      RankWorker.new.perform(user.id)
      result = $redis.zrevrank(key, @user.id)
    end
    
    result.try(:+, 1)
  end
  
  def count(key)
    $redis.zcard(key)
  end
end
