class UserRank
  attr_accessor :user, :language, :stars_count, :repository_count
  
  def initialize(user, language, stars_count, repository_count)
    @user = user
    @language = language
    @stars_count = stars_count
    @repository_count = repository_count
  end
  
  def city_rank
    rank("user_#{@user.city}_#{@language}")
  end
  
  def country_rank
    rank("user_#{@user.country}_#{@language}")
  end
  
  def world_rank
    rank("user_#{@language}")
  end
  
  def city_user_count
    count("user_#{@user.city}_#{@language}")
  end
  
  def country_user_count
    count("user_#{@user.country}_#{@language}")
  end
  
  def world_user_count
    count("user_#{@language}")
  end
  
  private
  def rank(key)
    $redis.zrevrank(key, @user.id)+1
  end
  
  def count(key)
    $redis.zcard(key)
  end
end
