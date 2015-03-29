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
  
  private
  def rank(key)
    $redis.zrevrank(key, @user.id).try(:+, 1 )
  end
  
  def count(key)
    $redis.zcard(key)
  end
end
